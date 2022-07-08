import 'package:flutter/material.dart';
import 'package:hourglass/components/player/bottom_bar.dart';
import 'package:hourglass/components/player/controller.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class Player extends StatelessWidget {
  final PlayerController controller;

  const Player({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PlayerController>(create: (_) => controller),
        ChangeNotifierProvider<PlayerState>(create: (_) => controller.state),
      ],
      builder: (BuildContext context, _) {
        return DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: ColoredBox(
            color: Colors.black,
            child: SafeArea(
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Center(
                      child: Consumer<PlayerController>(
                        builder: (BuildContext context, controller, _) {
                          print('Consumer builder');
                          if (controller.playerController == null) {
                            return const CircularProgressIndicator();
                          } else {
                            return AspectRatio(
                              aspectRatio: controller.playerController!.value.aspectRatio,
                              child: VideoPlayer(controller.playerController!),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  Positioned.fill(
                      child: GestureDetector(
                        onTap: () => print('tap'),
                        onDoubleTap: controller.switchPlayStatus,
                      )),
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [BackButton(color: Colors.white)],
                        ),
                        BottomBar(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
