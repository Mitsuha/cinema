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
      child = const CircularProgressIndicator();
    } else {
      child = AspectRatio(
        aspectRatio: controller.playerController!.value.aspectRatio,
        child: VideoPlayer(controller.playerController!),
      );
    }

    child = Center(child: child,);

    if (state.orientation == Orientation.portrait) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: child,
      );
    }
    return child;
  }
}
