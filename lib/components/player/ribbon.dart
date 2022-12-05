import 'package:flutter/material.dart';
import 'package:hourglass/components/player/components/full_bottom_bar.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:provider/provider.dart';
import 'components/simple_bottom_bar.dart';
import 'controller.dart';

class PlayerRibbon extends StatelessWidget {
  const PlayerRibbon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlayerController controller = context.read<PlayerController>();
    var state = context.watch<PlayerState>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// title bar
        Visibility(
          visible: state.ribbonVisibility ||
              (state.orientation == Orientation.portrait &&
                  !(controller.playerController?.value.isPlaying ?? false)),
          child: AnimatedOpacity(
            opacity: state.ribbonShow ||
                    (state.orientation == Orientation.portrait &&
                        !(controller.playerController?.value.isPlaying ?? false))
                ? 1
                : 0,
            duration: const Duration(milliseconds: 300),
            child: Row(
              children: [
                const BackButton(color: Colors.white),
                Expanded(
                  child: Text(
                    state.currentEpisode?.name ?? '',
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
          ),
        ),

        /// pause or play button
        Visibility(
          visible: state.orientation == Orientation.landscape && state.ribbonShow,
          child: Center(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                  boxShadow: [BoxShadow(blurRadius: 35, color: Colors.black87)]),
              child: ValueListenableBuilder<bool>(
                  valueListenable: state.playing,
                  builder: (context, isPlaying, _) {
                    return IconButton(
                      iconSize: 60,
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                        color: Colors.white,
                        shadows: const [Shadow(color: Colors.white, blurRadius: 50)],
                      ),
                      onPressed: controller.canControl ? controller.switchPlayStatus : null,
                    );
                  }),
            ),
          ),
        ),

        /// actions bar
        Visibility(
          visible: state.ribbonVisibility,
          maintainAnimation: true,
          maintainState: true,
          child: AnimatedOpacity(
            opacity: state.ribbonShow ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            onEnd: controller.updateRibbonVisibility,
            child: state.orientation == Orientation.portrait
                ? const SimpleBottomBar()
                : const FullBottomBar(),
          ),
        ),
      ],
    );
  }
}
