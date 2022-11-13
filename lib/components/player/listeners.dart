import 'package:hourglass/ali_driver/models/file.dart';

class PlayerListeners {
  bool Function(AliFile)? onSwitchEpisode;
  void Function()? videoAlmostOver;
  bool Function(Duration)? onSeek;
  bool Function(double)? onChangeSpeed;
  bool Function()? onPause;
  bool Function()? onPlay;

  PlayerListeners({
    this.onSwitchEpisode,
    this.videoAlmostOver,
    this.onChangeSpeed,
    this.onSeek,
    this.onPause,
    this.onPlay,
  });

  bool runOnSwitchEpisode(AliFile aliFile){
    if(onSwitchEpisode != null){
      return onSwitchEpisode!(aliFile);
    }

    return true;
  }

  bool runOnSeek(Duration duration){
    if(onSeek != null){
      return onSeek!(duration);
    }
    return true;
  }
  bool runOnChangeSpeed(double speed){
    if(onChangeSpeed != null){
      return onChangeSpeed!(speed);
    }
    return true;
  }

  bool runOnPause(){
    if(onPause != null){
      return onPause!();
    }
    return true;
  }
  bool runOnPlay(){
    if(onPlay != null){
      return onPlay!();
    }
    return true;
  }

}