import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:video_player/video_player.dart';
import '../../ali_driver/models/file.dart';
import '../../ali_driver/models/play_info.dart';
import '../../model/db.dart';

class PlayerController with ChangeNotifier {
  final PlayerState state = PlayerState();

  final Completer<VideoPlayerController> playerControllerCompleter = Completer();
  VideoPlayerController? playerController;

  PlayerController();

  _loadNewVideo(AliFile video) async {
    playerController?.dispose();
    playerController = null;

    if (!video.playInfoLoaded) {
      await video.loadPlayInfo();
    }

    playerController = VideoPlayerController.network(video.playInfo!.sources.last.url, httpHeaders: DB.originHeader);

    await playerController!.initialize();

    notifyListeners();
  }

  setPlayList(List<AliFile> playlist) {
    state.playlist = playlist;

    _loadNewVideo(state.playlist.first);
  }

  @override
  void dispose() {
    playerController?.dispose();
    super.dispose();
  }
}
