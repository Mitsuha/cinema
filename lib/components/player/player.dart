import 'package:flutter/material.dart';
import 'package:hourglass/components/player/bottom_bar.dart';
import 'package:hourglass/components/player/controller.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:hourglass/helpers.dart';

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

    widget.controller.init();
  }

  @override
  void dispose() {
    super.dispose();

    print('dispose');
    widget.controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('video player build');
    return MultiProvider(
      providers: [
        Provider<PlayerController>(create: (_) => widget.controller),
        ChangeNotifierProvider<PlayerState>(create: (_) => widget.controller.state),
        ChangeNotifierProvider<VideoPlayState>(create: (_) => widget.controller.videoPlayState),
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
                      if (state.brightUpdating || state.volumeUpdating) {
                        return SizedBox(
                          width: 160,
                          child: notifierWarp(
                            child: Row(
                              children: [
                                Icon(
                                  state.brightUpdating ? Icons.wb_sunny_outlined : Icons.volume_up,
                                  color: Colors.white,
                                  size: 19,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: state.brightUpdating
                                        ? state.brightValue
                                        : state.volumeValue,
                                    color: Colors.white,
                                    backgroundColor: const Color(0x30FFFFFF),
                                  ),
                                ),
                              ],
                            ),
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
