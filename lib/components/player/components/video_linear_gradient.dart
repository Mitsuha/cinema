import 'package:flutter/material.dart';

class VideoLinearGradient extends StatelessWidget {
  final Widget child;

  const VideoLinearGradient({required this.child,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x10000000), Color(0x90000000)],
            stops: [0.0, 0.39]),
      ),
      child: child,
    );
  }
}
