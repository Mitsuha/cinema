import 'package:flutter/material.dart';
import 'package:hourglass/components/player/controller.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:provider/provider.dart';

class VideoPlayList extends StatelessWidget {
  const VideoPlayList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlayerController controller = context.read<PlayerController>();
    PlayerState state = context.watch<PlayerState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(13, 20, 0, 13),
          child: Text('选集', style: TextStyle(color: Colors.grey),),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: state.playlist.length,
            itemBuilder: (BuildContext context, int i) {
              bool active = state.currentEpisode == state.playlist[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 2),
                child: InkWell(
                  radius: 6,
                  onTap: controller.canControl ? () => controller.selectEpisode(i) : null,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: active
                          ? Border.all(color: const Color(0xffff889c), width: 2)
                          : Border.all(color: const Color(0x30FFFFFF)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 13.9),
                      child: Text(
                        state.playlist[i].name,
                        style: active ? const TextStyle(color: Color(0xffff889c)) : null,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
