import 'package:flutter/material.dart';
import 'package:hourglass/components/player/components/menu.dart';
import 'package:hourglass/components/player/controller.dart';
import 'package:hourglass/components/player/components/detector.dart';
import 'package:hourglass/components/player/ribbon.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:hourglass/components/player/components/status_indication.dart';
import 'package:hourglass/components/player/components/video_container.dart';
import 'package:provider/provider.dart';

class Player extends StatefulWidget {
  final PlayerController controller;

  const Player({required this.controller, Key? key}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  void initState() {
    super.initState();

    widget.controller.initState();
  }

  @override
  void dispose() {
    super.dispose();

    widget.controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PlayerController>(create: (_) => widget.controller),
        ChangeNotifierProvider<PlayerState>(create: (_) => widget.controller.state),
        ChangeNotifierProvider<VideoPlayState>(create: (_) => widget.controller.videoPlayState),
      ],
      builder: (BuildContext context, _) {
        return DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: ColoredBox(
            color: Colors.black,
            child: OrientationBuilder(builder: (BuildContext context, Orientation orientation) {
              context.read<PlayerState>().orientation = orientation;

              Widget stack = Stack(
                fit: StackFit.loose,
                children: [
                  VideoContainer(),
                  const Positioned.fill(
                    child: Center(child: StatusIndication()),
                  ),
                  const Positioned.fill(
                    child: PlayerDetector(),
                  ),
                  Positioned.fill(
                    child: PlayerRibbon(),
                  ),
                  if (orientation == Orientation.landscape)
                    const PlayerMenu()
                ],
              );

              if (orientation == Orientation.landscape) {
                return stack;
              }

              return SafeArea(
                child: stack,
              );
            }),
          ),
        );
      },
    );
  }
}
