import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller.dart';

class VideoProgressBar extends StatelessWidget {
  var dragging = false;

  VideoProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = context.read<PlayerController>();

    if (!dragging) {
      controller.sliderValueNotifier.value = controller.playerController?.value.position.inSeconds.toDouble() ?? 0.0;
    }

    return ValueListenableBuilder(
      valueListenable: controller.sliderValueNotifier,
      builder: (BuildContext context, v, _) {
        return SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white,
            inactiveTrackColor: const Color(0x50FFFFFF),
            trackShape: const RectangularSliderTrackShape(),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayColor: const Color(0x60FFFFFF),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
            thumbColor: Colors.white,
          ),
          child: Slider(
            min: 0,
            max: controller.playerController?.value.duration.inSeconds.toDouble() ?? 100,
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
    );
  }
}
