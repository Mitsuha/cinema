import 'package:flutter/material.dart';
import 'package:hourglass/components/player/components/progress_bar.dart';
import 'package:hourglass/components/player/components/video_linear_gradient.dart';
import 'package:hourglass/components/player/controller.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:hourglass/helpers.dart';
import 'package:provider/provider.dart';

class FullBottomBar extends StatelessWidget {
  static const ButtonStyle buttonStyle = ButtonStyle(

    textStyle: MaterialStatePropertyAll(TextStyle(color: Colors.white))
  );

  const FullBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = context.read<PlayerController>();
    return SizedBox(
      height: 100,
      child: VideoLinearGradient(
        child: Column(
          children: [
            Consumer<VideoPlayState>(builder: (context, state, _) {
              return Expanded(
                child: Row(children: [
                  Text(
                    controller.playerController?.value.duration.toVideoString() ?? '00:00',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Expanded(child: VideoProgressBar()),
                  Text(state.playingDuration.toVideoString(), style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 15),
                ]),
              );
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(onPressed: (){}, icon: Icon(Icons.playlist_play), label: Text('播放列表'),style: buttonStyle,),
                TextButton.icon(onPressed: (){}, icon: Icon(Icons.speed), label: Text('倍速播放'),style: buttonStyle,),
                TextButton.icon(onPressed: (){}, icon: Icon(Icons.hd_outlined), label: Text('清晰度'),style: buttonStyle,),
                TextButton.icon(onPressed: (){}, icon: Icon(Icons.playlist_play), label: Text('消息'),style: buttonStyle,),
            ],)
          ],
        ),
      ),
    );
  }
}
