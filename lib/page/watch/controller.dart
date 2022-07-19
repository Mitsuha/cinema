import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/components/player/controller.dart';
import 'package:hourglass/model/room.dart';
import 'package:hourglass/page/watch/state.dart';
import 'package:hourglass/websocket/ws.dart';

class WatchController {
  final PlayerController player = PlayerController();
  final WatchState state = WatchState();

  init(List<AliFile>? playlist, Room? room){
    if(playlist != null){
      Ws.instance.createRoom().then((value) {
        state.setRoom(Room.fromJson(value['payload']));
      });

      setPlayList(playlist);
    }
  }

  setPlayList(List<AliFile> playlist) {
    player.setPlayList(playlist);
  }

  dispose() {
    player.dispose();
  }

  selectEpisode(i) {
    state.setState(() => player.selectEpisode(i));
  }
}
