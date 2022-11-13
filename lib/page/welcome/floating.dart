import 'dart:math';

import 'package:flutter/material.dart';

class Floating extends StatefulWidget {
  const Floating({Key? key}) : super(key: key);

  @override
  State<Floating> createState() => _FloatingState();
}

class _FloatingState extends State<Floating> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )
    ..drive(CurveTween(curve: Curves.easeOut))
      ..repeat(reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    var diameter = screen.width * 1.9;

    return Stack(
      children: [
        Positioned(
          bottom: -diameter / 4,
          right: -diameter / 4,
          child: AnimatedBuilder(
              animation: _controller,
              builder: (context, Widget? _) {
                return Spot(
                    colors: const [Color(0xffc5e9f2), Color(0xffbfcff9)],
                    diameter: diameter + _controller.value * 20);
              }),
        ),
        Positioned(
          top: -diameter / 5,
          left: -diameter / 4,
          child: AnimatedBuilder(
              animation: _controller,
              builder: (context, Widget? _) {
                return Spot(
                  colors: const [Color(0xfffabcc1), Color(0xfffeb0c3)],
                  diameter: diameter - _controller.value * 15,
                );
              }),
        ),
        Positioned(
            top: 80,
            right: 30,
            child: AnimatedBuilder(
                animation: _controller,
                builder: (context, Widget? _) {
                  const r = 5;
                  var x = r * cos(365 * _controller.value * 3.14 / 180);
                  var y = r * sin(365 * _controller.value * 3.14 / 180);
                  return Transform.translate(
                    offset: Offset(x, y),
                    child: const Spot(color: Color(0xffe2d4f6), diameter: 100),
                  );
                })),
      ],
    );
  }
}

class Spot extends StatelessWidget {
  final Color? color;
  final List<Color>? colors;
  final double diameter;
  final double? radius;

  const Spot({Key? key, required this.diameter, this.color, this.colors, this.radius})
      : assert(colors != null || color != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        gradient: colors != null ? LinearGradient(colors: colors!) : null,
        borderRadius: BorderRadius.all(Radius.circular(radius ?? diameter / 2)),
      ),
      child: SizedBox(height: diameter / 2, width: diameter / 2),
    );
  }
}
