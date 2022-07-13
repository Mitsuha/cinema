import 'package:flutter/material.dart';
import 'package:hourglass/components/player/components/full_bottom_bar.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:provider/provider.dart';
import 'components/simple_bottom_bar.dart';
import 'controller.dart';

class PlayerRibbon extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  PlayerRibbon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlayerController controller = context.read<PlayerController>();
    var state = context.watch<PlayerState>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: state.ribbonVisibility ||
              (state.orientation == Orientation.portrait && !(controller.playerController?.value.isPlaying ?? false)),
          child: AnimatedOpacity(
            opacity: state.ribbonShow ||
                    (state.orientation == Orientation.portrait &&
                        !(controller.playerController?.value.isPlaying ?? false))
                ? 1
                : 0,
            duration: const Duration(milliseconds: 300),
            child: Row(
              children: [
                if (state.orientation == Orientation.portrait) const BackButton(color: Colors.white),
                if (state.orientation == Orientation.landscape)
                  IconButton(
                    color: Colors.white,
                    icon: const BackButtonIcon(),
                    onPressed: controller.cancelFullScreen,
                  ),
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
        Visibility(
          visible: state.orientation == Orientation.landscape && state.ribbonShow,
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Transform.translate(
                    offset: const Offset(34, 0),
                    child: IconButton(
                      iconSize: 60,
                      icon: Icon(
                        state.playing ? Icons.pause : Icons.play_arrow_rounded,
                        color: Colors.white,
                        shadows: const [Shadow(color: Colors.white, blurRadius: 50)],
                      ),
                      onPressed: controller.switchPlayStatus,
                    ),
                  ),
                ),
              ),
              IconButton(onPressed: (){}, icon: const Icon(Icons.keyboard_voice, color: Colors.white))
            ],
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
            child: state.orientation == Orientation.portrait ? const SimpleBottomBar() : FullBottomBar(),
          ),
        ),
      ],
    );
  }
}
