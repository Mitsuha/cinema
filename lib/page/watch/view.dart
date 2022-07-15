import 'package:flutter/material.dart';
import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/components/player/player.dart';
import 'package:hourglass/page/watch/controller.dart';
import 'package:hourglass/page/watch/interactive.dart';
import 'package:hourglass/page/watch/state.dart';
import 'package:provider/provider.dart';

class WatchPage extends StatefulWidget {
  final List<AliFile> playlist;

  const WatchPage({Key? key, required this.playlist}) : super(key: key);

  @override
  State<WatchPage> createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {
  final WatchController controller = WatchController();

  @override
  void initState() {
    super.initState();
    controller.setPlayList(widget.playlist);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<WatchController>(create: (_) => controller),
        ChangeNotifierProvider<WatchState>(create: (_) => controller.state),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: OrientationBuilder(builder: (context, Orientation orientation) {
        Player player = Player(controller: controller.player);

        if (orientation == Orientation.landscape) {
          return player;
        }
        return Column(
          children: [
            player,
            const Expanded(child: Interactive()),
          ],
        );
      }),),
    );
  }
}
