import 'package:flutter/material.dart';
import 'package:hourglass/components/player/controller.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class Player extends StatelessWidget {
  final PlayerController controller;

  const Player({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => controller,
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
                    child: Consumer<PlayerController>(builder: (BuildContext context, controller, _) {
                      print('Consumer builder');

                      if (controller.playerController == null) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return VideoPlayer(controller.playerController!);
                      }
                    }),
                  ),
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [BackButton(color: Colors.white)],
                        ),
                        Row(
                          children: [
                            Consumer<PlayerController>(builder: (BuildContext context, controller, _) {
                              var isPlaying = controller.playerController!.value.isPlaying;

                              return IconButton(
                                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow_rounded),
                                onPressed: () {},
                              );
                            })
                          ],
                        )
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
