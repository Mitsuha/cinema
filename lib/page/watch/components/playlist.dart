import 'package:flutter/material.dart';
import 'package:hourglass/page/watch/controller.dart';
import 'package:provider/provider.dart';
import 'package:hourglass/helpers.dart';
import '../state.dart';

class WatchPlayList extends StatelessWidget {
  const WatchPlayList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = context.read<WatchController>();
    var state = context.watch<WatchState>();

    var playlist = controller.player.playList;
    return Material(
      child: ListView.builder(
          itemCount: playlist.length, itemBuilder: (BuildContext context, int i) {
            return ListTile(
              contentPadding: const EdgeInsets.all(8),
              leading: Image.network(playlist[i].thumbnail),
              title: Text(playlist[i].name),
              subtitle: Row(
                children: [
                  Text(playlist[i].createdAt.diffForHuman()),
                  Text(playlist[i].size.toByteString()),
                ],
              ),
            );
      }),
    );
  }
}
