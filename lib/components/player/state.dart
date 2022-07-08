import 'package:flutter/foundation.dart';
import 'package:hourglass/ali_driver/models/file.dart';

class PlayerState with ChangeNotifier{
  var playlist = <AliFile>[];
  AliFile? currentPlayAliFile;

  var playing = false;
  int playingSeconds = 0;
  Duration playingDuration = const Duration();

  setPlayStatus(bool status){
    playing = status;
    notifyListeners();
  }

  setPlayingSeconds(int seconds){
    playingSeconds = seconds;
    notifyListeners();
  }

  setPlayingDuration(Duration duration){
    playingDuration = duration;
    notifyListeners();
  }

}