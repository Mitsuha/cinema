import 'package:flutter/material.dart';
import 'package:hourglass/basic.dart';
import 'package:hourglass/components/player/components/play_list.dart';
import 'package:hourglass/components/player/components/resolution.dart';
import 'package:hourglass/components/player/components/speed.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:provider/provider.dart';

class PlayerMenu extends StatelessWidget {
  const PlayerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widgetSize = MediaQuery.of(context).size;
    var width = widgetSize.width / 2.5;
    PlayerState state = context.read<PlayerState>();

    return ValueListenableBuilder<VideoMenu>(
      valueListenable: state.videoMenu,
      builder: (BuildContext context, menu, _){
        Widget child;

        switch(menu){
          case VideoMenu.playList:
            child = const VideoPlayList(); break;
          case VideoMenu.resolution:
            child = const SelectResolution(); break;
          case VideoMenu.speed:
            child = const SelectSpeed(); break;
          default:
            child = const SizedBox();
        }

        return AnimatedPositioned(
          duration: Basic.animationDuration,
          right: VideoMenu.none != menu ? 0 : -width,
          child: SizedBox(
            width: width,
            height: widgetSize.height,
            child: Material(
              color: const Color(0xC0000000),
              textStyle: const TextStyle(fontSize: 15, color: Colors.white, overflow: TextOverflow.ellipsis),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
