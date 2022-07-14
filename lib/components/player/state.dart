import 'package:flutter/services.dart';
import 'package:hourglass/ali_driver/models/file.dart';
import 'package:flutter/material.dart';

enum VideoMenu{
  none,
  playList,
  speed,
  resolution
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

class PlayerState with ChangeNotifier{
  var playlist = <AliFile>[];
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
  var orientation = Orientation.portrait;
  var deviceOrientation = DeviceOrientation.portraitUp;
  var videoMenu = VideoMenu.none;

  AliFile? currentEpisode;

  setVideoControllerInitialing(bool initialing){
    if(initialing == videoControllerInitialing){
      return;
    }
    videoControllerInitialing = initialing;
    notifyListeners();
  }

  setCurrentEpisode(AliFile file){
    currentEpisode = file;
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

  setOrientation(Orientation o){
    if(orientation == o){
      return;
    }
    orientation = o;
    notifyListeners();
  }

  setVideoMenu(VideoMenu menu){
    videoMenu = menu;
    notifyListeners();
  }

}
