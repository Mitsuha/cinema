import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hourglass/ali_driver/api.dart';
import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/ali_driver/models/play_info.dart';
import 'package:hourglass/basic.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PlayerController {
  final PlayerState state = PlayerState();
  final VideoPlayState videoPlayState = VideoPlayState();
  final VolumeController volumeController = VolumeController()
    ..showSystemUI = false;
  final ScreenBrightness screenBrightness = ScreenBrightness();
  final ValueNotifier sliderValueNotifier = ValueNotifier(0.0);

  StreamSubscription? sensorsStreamSubscription;
  VideoPlayerController? playerController;
  double basicY = 0;
  double rotateY = 0;

  PlayerController();

  initState() {
    volumeController.listener((v) {
      if (!state.volumeUpdating) {
        return state.setVolumeValue(v);
      }
    });
    screenBrightness.onCurrentBrightnessChanged.listen((v) {
      if (!state.volumeUpdating) {
        state.setBrightValue(v);
      }
    });
  }

  registerSensorsListener() {
    const sen = 3.6;
    sensorsStreamSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      if (basicY == 0 && rotateY == 0) {
        rotateY = basicY = event.y;
      }
      rotateY += event.y;

      if ((rotateY - basicY).abs() > 8) {
        if (state.deviceOrientation == DeviceOrientation.landscapeRight) {
          rotateY = basicY + sen;
        } else if (state.deviceOrientation == DeviceOrientation.landscapeLeft) {
          rotateY = basicY - sen;
        }
      }

      if (rotateY - basicY < -sen && state.deviceOrientation == DeviceOrientation.landscapeRight) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft, //全屏时旋转方向，左边
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        state.deviceOrientation = DeviceOrientation.landscapeLeft;
      }
      if (rotateY - basicY > sen && state.deviceOrientation == DeviceOrientation.landscapeLeft) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight, //全屏时旋转方向，左边
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        state.deviceOrientation = DeviceOrientation.landscapeRight;
      }
    });
  }

  selectEpisode(int i) async {
    AliFile episode = state.playlist[i];

    if (!episode.playInfoLoaded) {
      await episode.loadPlayInfo();
    }
    state.setCurrentEpisode(episode);

    _loadNewVideo(episode.playInfo!.useTheBast());

    switchPlayStatus();

    if ((episode.videoMetadata?.width ?? 0) >= 1080) {
      loadOriginVideo(episode).then((_) {
        if (episode.videoMetadata!.height != 1080) {
          Fluttertoast.showToast(msg: '本视频可选原画画质');
        }
      });
    }
  }

  switchSubtitle(Subtitle subtitle){
    if (playerController == null) {
      return;
    }

    if (state.currentEpisode?.playInfo?.useSubtitle(subtitle) == null) {
      return;
    }

  }

  switchResolution(Source source) async {
    if (playerController == null) {
      return;
    }

    var position = playerController!.value.position;

    if (state.currentEpisode?.playInfo?.useSource(source) == null) {
      return;
    }

    await _loadNewVideo(source);
    playerController!.seekTo(position);
    switchPlayStatus();
  }

  _loadNewVideo(Source source) async {
    playerController?.dispose();
    playerController = null;
    state.setVideoControllerInitialing(true);

    try{
      playerController = VideoPlayerController.network(
        source.url,
        httpHeaders: Basic.originHeader,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true, allowBackgroundPlayback: true),
      );
    }catch(e){
      Fluttertoast.showToast(msg: '视频加载失败，建议返回重进');

      state.setVideoControllerInitialing(false);
      return;
    }

    playerController!.addListener(() {
      videoPlayState.setPlayingDuration(playerController!.value.position);
    });

    await playerController!.initialize();

    state.setVideoControllerInitialing(false);
  }

  setPlayList(List<AliFile> playlist) {
    state.playlist = playlist;

    selectEpisode(0);
  }

  List<AliFile> get playList {
    return state.playlist;
  }

  setPlaySpeed(double speed) {
    playerController?.setPlaybackSpeed(speed);
    state.setVideoMenu(VideoMenu.none);
  }

  switchPlayStatus() async {
    if (playerController == null) {
      return;
    }

    playerController!.value.isPlaying
        ? await playerController!.pause()
        : await playerController!.play();

    state.setPlayStatus(playerController!.value.isPlaying);
  }

  switchRibbon() {
    if (state.videoMenu != VideoMenu.none) {
      state.setVideoMenu(VideoMenu.none);
      return;
    }

    if (state.ribbonShow == false) {
      state.ribbonVisibility = true;
    }

    state.setRibbonShow(!state.ribbonShow);
  }

  updateRibbonVisibility() {
    state.setRibbonVisibility(state.ribbonShow);
  }

  seekTo(int seconds) {
    if (playerController == null) {
      return;
    }

    playerController!.seekTo(Duration(seconds: seconds));
  }

  addFastForwardTo(DragUpdateDetails details) {
    if (playerController == null) {
      return;
    }
    int second = state.fastForwardTo == Duration.zero
        ? playerController!.value.position.inSeconds
        : state.fastForwardTo.inSeconds;

    state.setFastForwardTo(Duration(seconds: second + (details.delta.dx * 3).toInt()));
  }

  doFastForward(DragEndDetails _) {
    playerController?.seekTo(state.fastForwardTo);
    state.setFastForwardTo(Duration.zero);
  }

  addBright(DragUpdateDetails details) {
    var bright = state.brightValue;

    if (details.delta.dy == 0) {
      return;
    }
    if (!state.brightUpdating) {
      state.setBrightUpdating(true);
    }

    bright -= (details.delta.dy / 100);
    bright = max(min(bright, 1.0), 0);

    screenBrightness.setScreenBrightness(bright);
    state.setBrightValue(bright);
  }

  addVolume(DragUpdateDetails details) async {
    var volume = state.volumeValue;

    if (details.delta.dy == 0) {
      return;
    }
    if (!state.volumeUpdating) {
      state.setVolumeUpdating(true);
    }

    volume -= (details.delta.dy / 100);
    volume = max(min(volume, 1.0), 0);

    volumeController.setVolume(volume);
    state.setVolumeValue(volume);
  }

  addBrightOrVolumeDone(DragEndDetails _) {
    if (state.volumeUpdating) {
      state.setVolumeUpdating(false);
    } else if (state.brightUpdating) {
      state.setBrightUpdating(false);
    }
  }

  onDetectorDone() {
    state.volumeUpdating = false;
    state.brightUpdating = false;
    state.fastForwardTo = Duration.zero;
    state.notifyListeners();
  }

  fullScreen() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft, //全屏时旋转方向，左边
      DeviceOrientation.landscapeRight
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    state.deviceOrientation = DeviceOrientation.landscapeLeft;
    registerSensorsListener();
  }

  cancelFullScreen() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, //全屏时旋转方向，左边
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  showPlayList() {
    state.ribbonShow = false;
    state.ribbonVisibility = false;
    state.setVideoMenu(VideoMenu.playList);
  }

  showResolution() {
    state.ribbonShow = false;
    state.ribbonVisibility = false;
    state.setVideoMenu(VideoMenu.resolution);
  }

  showSpeed() {
    state.ribbonShow = false;
    state.ribbonVisibility = false;
    state.setVideoMenu(VideoMenu.speed);
  }

  showSubtitle() {
    state.ribbonShow = false;
    state.ribbonVisibility = false;
    state.setVideoMenu(VideoMenu.subtitle);
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

  void dispose() {
    playerController?.dispose();
    sliderValueNotifier.dispose();
    volumeController.removeListener();
    sensorsStreamSubscription?.cancel();
  }
}
