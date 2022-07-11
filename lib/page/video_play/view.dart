import 'package:flutter/material.dart';
import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/components/player/controller.dart';
import 'package:hourglass/components/player/player.dart';
import 'package:hourglass/page/video_play/controller.dart';

class VideoPlayPage extends StatefulWidget {
  final List<AliFile> playlist;

  VideoPlayPage({Key? key, required this.playlist}) : super(key: key) {
    PlayController.init(playlist: playlist);
  }

  @override
  State<VideoPlayPage> createState() => _VideoPlayPageState();
}

class _VideoPlayPageState extends State<VideoPlayPage> {
  final PlayController controller = PlayController.instance;
  PlayerController playerController = PlayerController();

  @override
  void initState() {
    super.initState();

    playerController.setPlayList(widget.playlist);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Player(
        controller: playerController,
      )
    );
  }
}
