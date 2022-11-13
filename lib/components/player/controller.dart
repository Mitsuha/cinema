import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hourglass/ali_driver/api.dart';
import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/ali_driver/models/play_info.dart';
import 'package:hourglass/basic.dart';
import 'package:hourglass/components/player/listeners.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wakelock/wakelock.dart';

class PlayerController {
  final PlayerState _state = PlayerState();
  final VideoPlayState videoPlayState = VideoPlayState();
  final VolumeController volumeController = VolumeController()..showSystemUI = false;
  final ScreenBrightness screenBrightness = ScreenBrightness();
  final bool canControl;
  late final PlayerListeners listeners;

  StreamSubscription? sensorsStreamSubscription;
  VideoPlayerController? playerController;
  double basicY = 0;
  double rotateY = 0;
  Timer? speedTimer;

  PlayerController({required this.canControl, PlayerListeners? listeners}) {
    this.listeners = listeners ?? PlayerListeners();
  }

  initState() {
    volumeController.listener((v) {
      if (!_state.volumeUpdating) {
        return _state.setVolumeValue(v);
      }
    });
    screenBrightness.onCurrentBrightnessChanged.listen((v) {
      if (!_state.volumeUpdating) {
        _state.setBrightValue(v);
      }
    });
  }

  PlayerState getState() {
    return _state;
  }

  List<AliFile> get playList => _state.playlist;

  AliFile? get currentEpisode => _state.currentEpisode;

  Duration get position => playerController?.value.position ?? Duration.zero;

  bool get isPlaying => _state.playing;

  registerSensorsListener() {
    const sen = 3.6;
    sensorsStreamSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      if (basicY == 0 && rotateY == 0) {
        rotateY = basicY = event.y;
      }
      rotateY += event.y;

      if ((rotateY - basicY).abs() > 8) {
        if (_state.deviceOrientation == DeviceOrientation.landscapeRight) {
          rotateY = basicY + sen;
        } else if (_state.deviceOrientation == DeviceOrientation.landscapeLeft) {
          rotateY = basicY - sen;
        }
      }

      if (rotateY - basicY < -sen && _state.deviceOrientation == DeviceOrientation.landscapeRight) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft, //全屏时旋转方向，左边
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        _state.deviceOrientation = DeviceOrientation.landscapeLeft;
      }
      if (rotateY - basicY > sen && _state.deviceOrientation == DeviceOrientation.landscapeLeft) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight, //全屏时旋转方向，左边
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        _state.deviceOrientation = DeviceOrientation.landscapeRight;
      }
    });
  }

  Future<void> selectEpisode(int i) async {
    AliFile episode = _state.playlist[i];

    if (!listeners.runOnSwitchEpisode(episode)) {
      return;
    }

    if (!episode.playInfoLoaded) {
      await episode.loadPlayInfo();
    }
    _state.setCurrentEpisode(episode);

    await _loadNewVideo(episode.playInfo!.useTheBast());

    await play();

    // if ((episode.videoMetadata?.width ?? 0) >= 1080) {
    //   loadOriginVideo(episode).then((_) {
    //     if (episode.videoMetadata!.height != 1080) {
    //       Fluttertoast.showToast(msg: '本视频可选原画画质');
    //     }
    //   });
    // }
  }

  switchSubtitle(Subtitle subtitle) {
    if (playerController == null) {
      return;
    }

    if (_state.currentEpisode?.playInfo?.useSubtitle(subtitle) == null) {
      return;
    }
  }

  switchResolution(Source source) async {
    if (playerController == null) {
      return;
    }

    var position = playerController!.value.position;

    if (_state.currentEpisode?.playInfo?.useSource(source) == null) {
      return;
    }

    await _loadNewVideo(source);
    playerController!.seekTo(position);
    switchPlayStatus();
  }

  _loadNewVideo(Source source) async {
    playerController?.dispose();
    playerController = null;
    _state.setVideoControllerInitialing(true);

    try {
      playerController = VideoPlayerController.network(
        source.url,
        httpHeaders: Basic.originHeader,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true, allowBackgroundPlayback: true),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: '视频加载失败，建议返回重进');

      _state.setVideoControllerInitialing(false);
      return;
    }

    playerController!.addListener(() {
      videoPlayState.setPlayingDuration(playerController!.value.position);
    });

    await playerController!.initialize();

    _state.setVideoControllerInitialing(false);
  }

  setPlayList(List<AliFile> playlist, {bool autoplay = false}) {
    _state.playlist = playlist;

    if (autoplay) {
      selectEpisode(0);
    }
  }

  setPlaySpeed(double speed) {
    if (listeners.runOnChangeSpeed(speed)) {
      playerController?.setPlaybackSpeed(speed);
      _state.setVideoMenu(VideoMenu.none);
    }
  }

  /// 用户点击播放按钮触发的事件
  switchPlayStatus() async {
    if (playerController == null) {
      return;
    }

    if (playerController!.value.isPlaying) {
      if(listeners.runOnPause()){
        await pause();
      }
    } else if (listeners.runOnPlay()) {
      await play();
    }
  }

  switchRibbon() {
    if (_state.videoMenu != VideoMenu.none) {
      _state.setVideoMenu(VideoMenu.none);
      return;
    }

    if (_state.ribbonShow == false) {
      _state.ribbonVisibility = true;
    }

    _state.setRibbonShow(!_state.ribbonShow);
  }

  updateRibbonVisibility() {
    _state.setRibbonVisibility(_state.ribbonShow);
  }

  seekTo(Duration duration) {
    if (playerController == null) {
      return;
    }
    if (listeners.runOnSeek(duration)) {
      speedTimer?.cancel();

      playerController!.seekTo(duration);

      // if (playerController!.value.isPlaying) {
      //   playerController!.play();
      // }
    }
  }

  speedTo(double speed, double targetSpeed, Duration target) {
    if (playerController == null) {
      return;
    }
    Duration current = playerController!.value.position;
    if (current > target) {
      playerController!.setPlaybackSpeed(targetSpeed);

      seekTo(target);
      return;
    }

    var speedDuration =
        Duration(microseconds: (current - target).inMicroseconds.abs() ~/ (speed - targetSpeed));
    if (current + speedDuration > playerController!.value.duration) {
      seekTo(target);
    }

    playerController!.setPlaybackSpeed(speed);
    speedTimer?.cancel();
    speedTimer = Timer(speedDuration, () {
      playerController?.setPlaybackSpeed(targetSpeed);
    });
  }

  addFastForwardTo(DragUpdateDetails details) {
    if (playerController == null) {
      return;
    }
    int millisecond = _state.fastForwardTo == Duration.zero
        ? playerController!.value.position.inMilliseconds
        : _state.fastForwardTo.inMilliseconds;

    _state.setFastForwardTo(Duration(milliseconds: millisecond + (details.delta.dx * 100).toInt()));
  }

  doFastForward(DragEndDetails _) {
    seekTo(_state.fastForwardTo);

    _state.setFastForwardTo(Duration.zero);
  }

  addBright(DragUpdateDetails details) {
    var bright = _state.brightValue;

    if (details.delta.dy == 0) {
      return;
    }
    if (!_state.brightUpdating) {
      _state.setBrightUpdating(true);
    }

    bright -= (details.delta.dy / 100);
    bright = max(min(bright, 1.0), 0);

    screenBrightness.setScreenBrightness(bright);
    _state.setBrightValue(bright);
  }

  addVolume(DragUpdateDetails details) async {
    var volume = _state.volumeValue;

    if (details.delta.dy == 0) {
      return;
    }
    if (!_state.volumeUpdating) {
      _state.setVolumeUpdating(true);
    }

    volume -= (details.delta.dy / 100);
    volume = max(min(volume, 1.0), 0);

    volumeController.setVolume(volume);
    _state.setVolumeValue(volume);
  }

  addBrightOrVolumeDone(DragEndDetails _) {
    if (_state.volumeUpdating) {
      _state.setVolumeUpdating(false);
    } else if (_state.brightUpdating) {
      _state.setBrightUpdating(false);
    }
  }

  onDetectorDone() {
    _state.setState(() {
      _state.volumeUpdating = false;
      _state.brightUpdating = false;
      _state.fastForwardTo = Duration.zero;
    });
  }

  fullScreen() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft, //全屏时旋转方向，左边
      DeviceOrientation.landscapeRight
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _state.deviceOrientation = DeviceOrientation.landscapeLeft;
    registerSensorsListener();
  }

  Future<void> cancelFullScreen() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, //全屏时旋转方向，左边
    ]);
    _state.deviceOrientation = DeviceOrientation.portraitUp;
    sensorsStreamSubscription?.cancel();
    return;
  }

  showPlayList() {
    _state.ribbonShow = false;
    _state.ribbonVisibility = false;
    _state.setVideoMenu(VideoMenu.playList);
  }

  showResolution() {
    _state.ribbonShow = false;
    _state.ribbonVisibility = false;
    _state.setVideoMenu(VideoMenu.resolution);
  }

  showSpeed() {
    _state.ribbonShow = false;
    _state.ribbonVisibility = false;
    _state.setVideoMenu(VideoMenu.speed);
  }

  showSubtitle() {
    _state.ribbonShow = false;
    _state.ribbonVisibility = false;
    _state.setVideoMenu(VideoMenu.subtitle);
  }

  Future<void> play() async {
    if (playerController != null) {
      Wakelock.enable();

      await playerController!.play();
      _state.setPlayStatus(true);
    }
  }

  Future<void> pause() async {
    if (playerController != null) {
      Wakelock.disable();

      await playerController!.pause();
      _state.setPlayStatus(false);
    }
  }

  sendNotification(Text content, Duration duration) {
    print(content.data);
  }

  Future<void> loadOriginVideo(AliFile file) async {
    if (file.playInfo == null || file.videoMetadata == null) {
      return;
    }
    for (var s in file.playInfo!.sources) {
      if (s.resolution.contains('原画')) {
        return;
      }
    }

    var response = await AliDriver.downloadUrl(file.fileID);
    var meta = file.videoMetadata!;

    file.playInfo!.sources.insert(
        0, Source(url: response.body['cdn_url'], resolution: "${meta.width}x${meta.height} 原画"));
  }

  Future dispose() async {
    await playerController?.dispose();
    volumeController.removeListener();
    sensorsStreamSubscription?.cancel();
  }
}
