import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../controller.dart';

class VideoProgressBar extends StatefulWidget {
  final Duration? current;
  final Duration? max;

  const VideoProgressBar({this.max, this.current, Key? key}) : super(key: key);

  @override
  State<VideoProgressBar> createState() => _VideoProgressBarState();
}

class _VideoProgressBarState extends State<VideoProgressBar> {
  late PlayerController _controller;
  var dragging = false;
  var current = 0.0;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _controller = context.read<PlayerController>();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!dragging) {
      current = widget.current?.inSeconds.toDouble() ?? 0;
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
        max: widget.max?.inSeconds.toDouble() ?? 1,
        value: current,
        onChanged: (newValue) => setState(() => current = newValue),
        onChangeStart: (_) => dragging = true,
        onChangeEnd: (newValue) {
          dragging = false;
          _controller.seekTo(Duration(seconds: newValue.toInt()));
        },
      ),
    );
  }
}
