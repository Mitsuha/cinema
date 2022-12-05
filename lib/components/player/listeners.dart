import 'package:hourglass/ali_driver/models/file.dart';

abstract class PlayerEvent {
  inited() {}

  dispose() {}

  Future<bool> onSwitchEpisode(int index, AliFile episode) async => true;

  bool onSeek(Duration duration) => true;

  bool onChangeSpeed(double speed) => true;

  bool onChangeStatus(bool playing) => true;

  bool onUpdatePlaylist(List<AliFile> playlist) => true;
}

class EmptyPlayerListener extends PlayerEvent {}
