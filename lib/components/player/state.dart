import 'package:flutter/foundation.dart';
import 'package:hourglass/ali_driver/models/file.dart';

class PlayerState with ChangeNotifier{
  var playlist = <AliFile>[];
  AliFile? currentPlayAliFile;

  var playing = false;
  var ribbonShow = true;
  var ribbonVisibility = true;
  var videoControllerInitialing = true;
  var videoCaching = false;
  var fastForwardTo = Duration.zero;
  var volumeUpdating = false;
  var volumeValue = .0;
  var brightUpdating = false;
  var brightValue = .0;

  setVideoControllerInitialing(bool initialing){
    if(initialing == videoControllerInitialing){
      return;
    }
    videoControllerInitialing = initialing;
    notifyListeners();
  }

  setPlayStatus(bool status){
    if(playing == status){
      return;
    }
    playing = status;
    notifyListeners();
  }


  setFastForwardTo(Duration forward){
    fastForwardTo = forward;
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

  setVolumeValue(double v){
    volumeValue = v;
    notifyListeners();
  }

  setBrightUpdating(bool update){
    brightUpdating = update;
    notifyListeners();
  }

  setBrightValue(double v){
    brightValue = v;
    notifyListeners();
  }

}

class VideoPlayState with ChangeNotifier{
  int playingSeconds = 0;
  Duration playingDuration = const Duration();

  setPlayingSeconds(int seconds){
    playingSeconds = seconds;
    notifyListeners();
  }

  setPlayingDuration(Duration duration){
    playingDuration = duration;
    notifyListeners();
  }

}