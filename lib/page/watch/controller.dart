import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/components/player/controller.dart';
import 'package:hourglass/page/watch/state.dart';

class WatchController {
  final PlayerController player = PlayerController();
  final WatchState state = WatchState();

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
