import 'package:flutter/material.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:provider/provider.dart';
import 'controller.dart';
import 'package:hourglass/helpers.dart';

class BottomBar extends StatelessWidget {
  static const double iconButtonSize = 39;

  var dragging = false;

  BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = context.read<PlayerController>();
    var state = context.watch<PlayerState>();

    if (!dragging) {
      controller.sliderValueNotifier.value =
          controller.playerController?.value.position.inSeconds.toDouble() ?? 0.0;
    }

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x10000000), Color(0x90000000)],
            stops: [0.0, 0.39]),
      ),
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
              child: Row(children: [
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: controller.sliderValueNotifier,
                    builder: (BuildContext context, v, _) {
                      return SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: const Color(0x30FFFFFF),
                          trackShape: const RectangularSliderTrackShape(),
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                          overlayColor: const Color(0x60FFFFFF),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                          thumbColor: Colors.white,
                        ),
                        child: Slider(
                          min: 0,
                          max: controller.playerController?.value.duration.inSeconds.toDouble() ??
                              100,
                          value: (v as double),
                          onChanged: (newValue) {
                            controller.sliderValueNotifier.value = newValue;
                          },
                          onChangeStart: (_) => dragging = true,
                          onChangeEnd: (newValue) {
                            dragging = false;
                            controller.seekTo(newValue.toInt());
                          },
                        ),
                      );
                    },
                  ),
                ),
                Text(
                  "${controller.playerController?.value.duration.toVideoString() ?? '00:00'}/${state.playingDuration.toVideoString()}",
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
