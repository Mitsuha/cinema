import 'package:flutter/material.dart';
import 'package:hourglass/components/player/components/progress_bar.dart';
import 'package:hourglass/components/player/components/video_linear_gradient.dart';
import 'package:hourglass/components/player/controller.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:hourglass/helpers.dart';
import 'package:provider/provider.dart';

class FullBottomBar extends StatelessWidget {

  const FullBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = context.read<PlayerController>();
    return VideoLinearGradient(
      child: Column(
        children: [
          Consumer<VideoPlayState>(builder: (context, state, _) {
            return Row(children: [
              Text(state.playingDuration.toVideoString(), style: const TextStyle(fontSize: 12)),
              const Expanded(child: VideoProgressBar()),
              Text(
                controller.playerController?.value.duration.toVideoString() ?? '00:00',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 15),
            ]);
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: controller.showPlayList,
                icon: const Icon(Icons.playlist_play,color: Colors.white),
                label: const Text('播放列表', style: TextStyle(color:Colors.white)),
              ),
              TextButton.icon(
                onPressed: controller.showSpeed,
                icon: const Icon(Icons.speed, color:Colors.white),
                label: const Text('倍速播放', style: TextStyle(color:Colors.white)),
              ),
              TextButton.icon(
                onPressed: controller.showResolution,
                icon: const Icon(Icons.hd_outlined, color:Colors.white),
                label: const Text('清晰度', style: TextStyle(color:Colors.white)),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat_outlined, color:Colors.white, size: 20),
                label: const Text('消息', style: TextStyle(color:Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 3)
        ],
      ),
    );
  }
}
