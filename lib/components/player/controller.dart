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

    if (!video.playInfoLoaded) {
      await video.loadPlayInfo();
    }

    playerController = VideoPlayerController.network(video.playInfo!.sources.last.url,
        httpHeaders: DB.originHeader);

    playerController!.addListener(() {
      state.setPlayingDuration(playerController!.value.position);
    });

    await playerController!.initialize();

    notifyListeners();
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

  seekTo(int seconds) {
    if (playerController == null) {
      return;
    }

    playerController!.seekTo(Duration(seconds: seconds));

    state.setPlayingSeconds(seconds);
  }

  @override
  void dispose() {
    super.dispose();

    playerController?.dispose();
    sliderValueNotifier.dispose();
  }
}
