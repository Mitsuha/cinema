import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller.dart';
import '../state.dart';

class VideoProgressBar extends StatefulWidget {

  // ignore: prefer_const_constructors_in_immutables
  VideoProgressBar({Key? key}) : super(key: key);

  @override
  State<VideoProgressBar> createState() => _VideoProgressBarState();
}

class _VideoProgressBarState extends State<VideoProgressBar> {
  var dragging = false;
  var current = 0.0;

  @override
  Widget build(BuildContext context) {
    var controller = context.read<PlayerController>();

    if (!dragging) {
      current = controller.playerController?.value.position.inSeconds.toDouble() ?? 0;
    }

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
        value: current,
        onChanged: (newValue) => setState(() => current = newValue),
        onChangeStart: (_) => dragging = true,
        onChangeEnd: (newValue) {
          dragging = false;
          controller.seekTo(Duration(seconds: newValue.toInt()));
        },
      ),
    );
  }
}
