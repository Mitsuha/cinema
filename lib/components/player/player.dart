import 'package:flutter/material.dart';
import 'package:hourglass/components/player/bottom_bar.dart';
import 'package:hourglass/components/player/controller.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:hourglass/helpers.dart';

class Player extends StatelessWidget {
  final PlayerController controller;

  const Player({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PlayerController>(create: (_) => controller),
        ChangeNotifierProvider<PlayerState>(create: (_) => controller.state),
      ],
      builder: (BuildContext context, _) {
        PlayerController controller = context.read<PlayerController>();

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
                      child: Consumer<PlayerState>(
                        builder: (BuildContext context, status, _) {
                          if (status.videoControllerInitialing) {
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
                    child: Center(child: Consumer<PlayerState>(builder: (context, state, _) {
                      if (state.fastForwardTo != Duration.zero) {
                        return notifierWarp(child: Text(state.fastForwardTo.toVideoString()));
                      }
                      if (state.volumeUpdating) {
                        return notifierWarp(
                          child: LinearProgressIndicator(
                            value: controller.playerController?.value.volume,
                            color: Colors.white,
                            backgroundColor: const Color(0x30FFFFFF),
                          ),
                        );
                      }
                      return const SizedBox();
                    })),
                  ),
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: controller.switchRibbon,
                      onDoubleTap: controller.switchPlayStatus,
                      onHorizontalDragUpdate: controller.addFastForwardTo,
                      onHorizontalDragEnd: controller.doFastForward,
                      onVerticalDragEnd: controller.addBrightOrVolumeDone,
                      onVerticalDragUpdate: (DragUpdateDetails details) {
                        var half = MediaQuery.of(context).size.width / 2;

                        if (details.globalPosition.dx > half) {
                          controller.addVolume(details);
                        } else {
                          controller.addBright(details);
                        }
                      },
                    ),
                  ),
                  Positioned.fill(
                    child: Consumer<PlayerState>(builder: (context, state, _) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: state.ribbonVisibility ||
                                !(controller.playerController?.value.isPlaying ?? false),
                            child: AnimatedOpacity(
                              opacity: state.ribbonShow ||
                                      !(controller.playerController?.value.isPlaying ?? false)
                                  ? 1
                                  : 0,
                              duration: const Duration(milliseconds: 300),
                              child: Row(
                                children: const [BackButton(color: Colors.white)],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: state.ribbonVisibility,
                            maintainAnimation: true,
                            maintainState: true,
                            child: AnimatedOpacity(
                              opacity: state.ribbonShow ? 1 : 0,
                              duration: const Duration(milliseconds: 300),
                              onEnd: controller.updateRibbonVisibility,
                              child: BottomBar(),
                            ),
                          ),
                        ],
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget notifierWarp({required Widget child}) => DecoratedBox(
        decoration: const BoxDecoration(
          color: Color(0x90000000),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          child: child,
        ),
      );
}
