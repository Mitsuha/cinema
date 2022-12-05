import 'package:flutter/material.dart';
import 'package:hourglass/components/player/components/progress_bar.dart';
import 'package:hourglass/components/player/components/video_linear_gradient.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:provider/provider.dart';
import '../controller.dart';
import 'package:hourglass/helpers.dart';

class SimpleBottomBar extends StatelessWidget {
  static const double iconButtonSize = 39;

  const SimpleBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = context.read<PlayerController>();
    var state = context.read<PlayerState>();

    return VideoLinearGradient(
      child: Row(
        children: [
          /// show playing status
          ValueListenableBuilder<bool>(
              valueListenable: state.playing,
              builder: (context, isPlaying, _) {
                return SizedBox(
                  width: iconButtonSize,
                  child: IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                      color: Colors.white,
                    ),
                    onPressed: controller.canControl ? controller.switchPlayStatus : null,
                  ),
                );
              }),

          /// show Duration
          ValueListenableBuilder<Duration>(
              valueListenable: controller.state.playingDuration,
              builder: (context, duration, _) {
                return Expanded(
                  child: Row(children: [
                    Expanded(
                        child: !controller.canControl
                            ? const SizedBox()
                            : VideoProgressBar(
                                max: controller.playerController?.value.duration,
                                current: duration,
                              )),
                    Text(
                      "${controller.duration.humanRead()}/${duration.humanRead()}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ]),
                );
              }),
          SizedBox(
            width: iconButtonSize,
            child: IconButton(
              icon: const Icon(Icons.fullscreen, color: Colors.white),
              onPressed: controller.fullScreen,
            ),
          ),
        ],
      ),
    );
  }
}
