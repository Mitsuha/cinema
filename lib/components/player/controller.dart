import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_controller/volume_controller.dart';
import '../../ali_driver/models/file.dart';
import '../../ali_driver/models/play_info.dart';
import '../../model/db.dart';

class PlayerController with ChangeNotifier {
  final PlayerState state = PlayerState();
  final VideoPlayState videoPlayState = VideoPlayState();
  final VolumeController volumeController = VolumeController()..showSystemUI = false;
  final ScreenBrightness screenBrightness = ScreenBrightness();
  final ValueNotifier sliderValueNotifier = ValueNotifier(0.0);

  VideoPlayerController? playerController;

  PlayerController();

  init() {
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

  selectEpisode(int i) async {
    AliFile episode = state.playlist[i];

    if (!episode.playInfoLoaded) {
      await episode.loadPlayInfo();
    }
    state.setCurrentEpisode(episode);

    _loadNewVideo(episode.playInfo!.useTheBast());

    switchPlayStatus();
  }

  _loadNewVideo(Source source) async {
    playerController?.dispose();
    playerController = null;
    state.setVideoControllerInitialing(true);

    playerController = VideoPlayerController.network(source.url, httpHeaders: DB.originHeader);

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

  switchPlayStatus() {
    if (playerController == null) {
      return;
    }

    playerController!.value.isPlaying ? playerController!.pause() : playerController!.play();

    state.setPlayStatus(playerController!.value.isPlaying);
  }

  switchRibbon() {
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

  onDetectorDone(){
    state.volumeUpdating = false;
    state.brightUpdating = false;
    state.fastForwardTo = Duration.zero;
    state.notifyListeners();
  }

  fullScreen(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft, //全屏时旋转方向，左边
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  cancelFullScreen(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, //全屏时旋转方向，左边
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  void dispose() {
    super.dispose();

    playerController?.dispose();
    sliderValueNotifier.dispose();
    volumeController.removeListener();
  }
}
