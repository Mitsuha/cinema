import 'package:hourglass/ali_driver/models/file.dart';
import '../../components/player/controller.dart';

class PlayController {
  static PlayController? _instance;

  PlayController._internal({required this.playlist});

  static init({required List<AliFile> playlist}) {
    _instance ??= PlayController._internal(playlist: playlist)..loadVideo(playlist.first);

    return _instance;
  }

  static PlayController get instance => _instance!;

  /// play list
  PlayerController playerController = PlayerController();
  List<AliFile> playlist = [];
  late AliFile currentFile;

  loadVideo(AliFile file){
    currentFile = file;

    // playerController.setPlayList(playlist);
  }

}
