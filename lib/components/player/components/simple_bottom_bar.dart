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
    var state = context.watch<PlayerState>();

    return VideoLinearGradient(
      child: Row(
        children: [
          SizedBox(
            width: iconButtonSize,
            child: IconButton(
              icon: Icon(
                state.playing ? Icons.pause : Icons.play_arrow_rounded,
                color: Colors.white,
              ),
              onPressed: controller.switchPlayStatus,
            ),
          ),
          Consumer<VideoPlayState>(builder: (context, state, _) {
            return Expanded(
              child: Row(
                  children: [
                    Expanded(
                      child: VideoProgressBar(),
                    ),
                    Text(
                      "${controller.playerController?.value.duration.toVideoString() ?? '00:00'}/${state.playingDuration
                          .toVideoString()}",
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
