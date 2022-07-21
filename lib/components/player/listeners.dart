import 'package:hourglass/ali_driver/models/file.dart';

typedef BoolCallback = bool Function();
typedef VoidCallback = void Function();

class PlayerListeners {
  bool Function(AliFile)? onSwitchEpisode;
  VoidCallback? videoAlmostOver;

  PlayerListeners({
    this.onSwitchEpisode,
    this.videoAlmostOver,
  });

  bool runOnSwitchEpisode(AliFile aliFile){
    if(onSwitchEpisode != null){
      return onSwitchEpisode!(aliFile);
    }
    return true;
  }
}