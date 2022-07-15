import 'package:flutter/material.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:provider/provider.dart';
import '../controller.dart';

class SelectSubtitle extends StatelessWidget {
  const SelectSubtitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlayerController controller = context.read<PlayerController>();
    PlayerState state = context.watch<PlayerState>();

    if (state.currentEpisode?.playInfo == null) {
      return const SizedBox();
    }
    var subtitles = state.currentEpisode!.playInfo!.subtitles;

    const TextStyle normal = TextStyle(color: Colors.white);
    const TextStyle active = TextStyle(color: Color(0xffff889c));

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for(var subtitle in subtitles)
          TextButton(
            child: Text(subtitle.language, style: subtitle.current ? active : normal),
            onPressed: () => controller.switchSubtitle(subtitle),
          ),
        ],
      ),
    );
  }
}
