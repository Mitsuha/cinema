import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hourglass/components/player/controller.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoContainer extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  VideoContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = context.watch<PlayerState>();
    var controller = context.read<PlayerController>();

    Widget child;
    if (state.videoControllerInitialing) {
      child = Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            state.playlist.first.thumbnail,
            errorBuilder: (_, __, ___) {
              return Image.asset('assets/images/cinema.png');
            },
          ),
          const Positioned.fill(child: ColoredBox(color: Colors.black38)),
          const LoadingProgressIndicator()
        ],
      );
    } else {
      child = Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: controller.playerController!.value.aspectRatio,
            child: VideoPlayer(controller.playerController!),
          ),
          PlayerProgressIndicator(controller.playerController!)
        ],
      );
    }

    child = Center(
      child: child,
    );

    if (state.orientation == Orientation.portrait) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: child,
      );
    }
    return child;
  }
}

class LoadingProgressIndicator extends StatelessWidget {
  const LoadingProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = min(100, MediaQuery.of(context).size.width);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
            width: width,
            child: const LinearProgressIndicator(
              backgroundColor: Color(0x60FFFFFF),
              color: Colors.white,
            )),
        const SizedBox(height: 6),
        const Text('载入中...', style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

class PlayerProgressIndicator extends StatefulWidget {
  final VideoPlayerController controller;

  const PlayerProgressIndicator(this.controller, {Key? key}) : super(key: key);

  @override
  State<PlayerProgressIndicator> createState() => _PlayerProgressIndicatorState();
}

class _PlayerProgressIndicatorState extends State<PlayerProgressIndicator> {
  bool isBuffering = false;

  @override
  void initState() {
    widget.controller.addListener(() {
      if (widget.controller.value.isBuffering && !isBuffering && mounted) {
        setState(() {
          isBuffering = true;
        });
      } else if (isBuffering && !widget.controller.value.isBuffering && mounted) {
        setState(() {
          isBuffering = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.value.isBuffering) {
      return const LoadingProgressIndicator();
    }

    return const SizedBox();
  }
}
