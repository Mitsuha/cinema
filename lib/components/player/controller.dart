import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:video_player/video_player.dart';
import '../../ali_driver/models/file.dart';
import '../../model/db.dart';

class PlayerController with ChangeNotifier {
  final PlayerState state = PlayerState();

  VideoPlayerController? playerController;

  final ValueNotifier sliderValueNotifier = ValueNotifier(0.0);

  PlayerController();

  _loadNewVideo(AliFile video) async {
    playerController?.dispose();
    playerController = null;
    state.setVideoControllerInitialing(true);

    if (!video.playInfoLoaded) {
      await video.loadPlayInfo();
    }

    playerController = VideoPlayerController.network(video.playInfo!.sources.last.url,
        httpHeaders: DB.originHeader);

    playerController!.addListener(() {
      state.setPlayingDuration(playerController!.value.position);
    });

    await playerController!.initialize();

    state.setVideoControllerInitialing(false);

    switchPlayStatus();
  }

  setPlayList(List<AliFile> playlist) {
    state.playlist = playlist;

    _loadNewVideo(state.playlist.first);
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

    state.setPlayingSeconds(seconds);
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
    print('addBright');
  }

  addVolume(DragUpdateDetails details) {
    if (playerController == null) {
      return;
    }
    var volume = playerController!.value.volume;

    volume -= (details.delta.dy / 100);

    playerController!.setVolume(max(min(volume, 1.0), 0));
    state.setVolumeUpdating(true);
  }

  addBrightOrVolumeDone(DragEndDetails _){
    if(state.volumeUpdating){
      state.setVolumeUpdating(false);
    }else if(state.brightUpdating){
      state.setBrightUpdating(false);
    }
  }

  @override
  void dispose() {
    super.dispose();

    playerController?.dispose();
    sliderValueNotifier.dispose();
  }
}
