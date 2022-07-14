import 'package:flutter/material.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:provider/provider.dart';
import '../controller.dart';

class SelectResolution extends StatelessWidget {
  const SelectResolution({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlayerController controller = context.read<PlayerController>();
    PlayerState state = context.watch<PlayerState>();

    if(state.currentEpisode?.playInfo == null){
      return const SizedBox();
    }

    var sources = state.currentEpisode!.playInfo!.sources;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < sources.length; i++)
            TextButton(
              onPressed: ()=> controller.switchResolution(i),
              child: Text(
                sources[i].resolutionFullName,
                style: TextStyle(color:sources[i].current ? const Color(0xffff889c) : Colors.white),
              ),
            )
        ],
      ),
    );
  }
}
