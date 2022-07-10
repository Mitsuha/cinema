import 'package:flutter/foundation.dart';
import 'package:hourglass/ali_driver/models/file.dart';

class PlayerState with ChangeNotifier{
  var playlist = <AliFile>[];
  AliFile? currentPlayAliFile;

  var playing = false;
  int playingSeconds = 0;
  Duration playingDuration = const Duration();
  var ribbonShow = true;
  var ribbonVisibility = true;
  var videoControllerInitialing = true;
  var videoCaching = false;
  var fastForwardTo = Duration.zero;
  var volumeUpdating = true;
  var brightUpdating = true;

  setVideoControllerInitialing(bool initialing){
    if(initialing == videoControllerInitialing){
      return;
    }
    videoControllerInitialing = initialing;
    notifyListeners();
  }

  setFastForwardTo(Duration forward){
    fastForwardTo = forward;
    notifyListeners();
  }

  setPlayStatus(bool status){
    if(playing == status){
      return;
    }
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

  setRibbonShow(bool show){
    ribbonShow = show;
    notifyListeners();
  }

  setRibbonVisibility(bool visible){
    if(ribbonVisibility == visible){
      return;
    }
    ribbonVisibility = visible;
    notifyListeners();
  }

  setVolumeUpdating(bool update){
    volumeUpdating = update;
    notifyListeners();
  }

  setBrightUpdating(bool update){
    brightUpdating = update;
    notifyListeners();
  }

}