import 'package:hourglass/ali_driver/models/file.dart';

class PlayerListeners {
  bool Function(AliFile)? onSwitchEpisode;
  void Function()? videoAlmostOver;
  bool Function(Duration)? onSeek;
  void Function()? onPause;
  void Function()? onPlay;

  PlayerListeners({
    this.onSwitchEpisode,
    this.videoAlmostOver,
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

  void runOnPause(){
    if(onPause != null){
      onPause!();
    }
  }
  void runOnPlay(){
    if(onPlay != null){
      onPlay!();
    }
  }

}