import 'dart:async';

import 'package:hourglass/ali_driver/api.dart';
import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/ali_driver/models/video.dart';
import 'package:hourglass/model/db.dart';
import 'package:video_player/video_player.dart';

class PlayController {
  static PlayController? _instance;

  PlayController._internal({required this.playlist});

  static init({required List<AliFile> playlist}) {
    if (_instance != null) {
      return;
    }
    return PlayController._internal(playlist: playlist)..loadVideo(playlist.first);
  }

  static get instance => _instance;

  /// play list
  List<AliFile> playlist = [];
  late AliFile currentFile;
  late Video currentVideo;

  /// play controller
  final Completer<VideoPlayerController> playerController = Completer();

  loadVideo(AliFile file){
    currentFile = file;
    AliDriver.videoPlayInfo(file.fileID).then((video){
      currentVideo = video;

      var videoController = VideoPlayerController.network('https://tup.yinghuacd.com/cache/Youzitsu201.m3u8', httpHeaders: DB.originHeader);
      videoController.initialize();

      playerController.complete(videoController);
    });
  }

}
