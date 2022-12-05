import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hourglass/components/player/player.dart';
import 'package:hourglass/model/room.dart';
import 'package:hourglass/page/watch/controller.dart';
import 'package:hourglass/page/watch/interactive.dart';
import 'package:hourglass/page/watch/state.dart';
import 'package:provider/provider.dart';

class WatchPage extends StatefulWidget {
  final Room room;

  const WatchPage({Key? key, required this.room}) : super(key: key);

  @override
  State<WatchPage> createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {
  late final WatchController controller = WatchController(room: widget.room);
  final playerKey = GlobalKey();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ));

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.subscriber.onDismissCall = () => Navigator.of(context).pop();

    final Player player = Player(
      key: playerKey,
      controller: controller.player,
    );

    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: MultiProvider(
        providers: [
          Provider<WatchController>(create: (_) => controller),
          ChangeNotifierProvider<WatchState>(create: (_) => controller.state),
          ChangeNotifierProvider<ChatState>(create: (_) => controller.chat),
        ],
        child: Material(
          color: Colors.white,
          child: OrientationBuilder(builder: (context, Orientation orientation) {
            if (orientation == Orientation.landscape) {
              return player;
            }
            return Column(
              children: [
                player,
                const Expanded(child: ColoredBox(color: Color(0xff1d1b29), child: Interactive())),
              ],
            );
          }),
        ),
      ),
    );
  }

  Future<bool> onWillPop(BuildContext context) async {
    if (controller.player.state.orientation == Orientation.landscape) {
      await controller.player.cancelFullScreen();
      return false;
    } else {
      bool back = false;
      await showDialog(
          context: context,
          builder: (BuildContext dialogCtx) {
            const style = TextStyle(color: Colors.white);
            return AlertDialog(
              backgroundColor: const Color(0xff151515),
              title: const Text("Wait...", style: style),
              content: const Text("确定要退出房间吗？", style: style),
              actions: [
                TextButton(
                  child: const Text('取消', style: TextStyle(color: Colors.grey)),
                  onPressed: () {
                    Navigator.of(dialogCtx).pop();
                    back = false;
                  },
                ),
                TextButton(
                  child: const Text('确定'),
                  onPressed: () {
                    controller.leaveRoom();
                    Navigator.of(dialogCtx).pop();
                    back = true;
                  },
                ),
              ],
            );
          });

      return back;
    }
  }
}
