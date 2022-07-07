import 'package:flutter/material.dart';
import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/page/video_play/controller.dart';

class VideoPlayPage extends StatefulWidget {
  final List<AliFile> playlist;

  VideoPlayPage({Key? key,required this.playlist}) : super(key: key) {
    PlayController.init(playlist: playlist);
  }

  @override
  State<VideoPlayPage> createState() => _VideoPlayPageState();
}

class _VideoPlayPageState extends State<VideoPlayPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // return Scaffold(
    //   body: ValueListenableBuilder(
    //     valueListenable: videoLoadedNotifier,
    //     builder: (BuildContext context, loaded, Widget? _) {
    //       if (!(loaded as bool)) {
    //         return const Center(child: CircularProgressIndicator());
    //       }
    //
    //       return AspectRatio(
    //         aspectRatio: _videoPlayerController!.value.aspectRatio,
    //         child: VideoPlayer(_videoPlayerController!),
    //       );
    //     },
    //   ),
    //   floatingActionButton: ValueListenableBuilder(
    //     valueListenable: videoLoadedNotifier,
    //     builder: (BuildContext context, loaded, Widget? _) {
    //       return FloatingActionButton(
    //         child: Icon(_videoPlayerController!.value.isPlaying
    //             ? Icons.pause
    //             : Icons.play_arrow),
    //         onPressed: () {
    //
    //           _videoPlayerController!.value.isPlaying
    //               ? _videoPlayerController!.pause()
    //               : _videoPlayerController!.play();
    //         },
    //       );
    //     },
    //   ),
    // );
  }

}
