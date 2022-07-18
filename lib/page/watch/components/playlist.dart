import 'package:flutter/material.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:hourglass/page/watch/controller.dart';
import 'package:provider/provider.dart';
import 'package:hourglass/helpers.dart';
import '../state.dart';

class WatchPlayList extends StatelessWidget {
  const WatchPlayList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = context.read<WatchController>();
    var _ = context.watch<WatchState>();

    var playlist = controller.player.playList;
    var current = controller.player.currentEpisode;

    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: playlist.length + 1,
        itemBuilder: (BuildContext context, int i) {
          if (i == playlist.length) {
            return IconButton(onPressed: () {}, icon: const Icon(Icons.add));
          }
          return ListTile(
            onTap: () => controller.selectEpisode(i),
            selected: current?.fileID == playlist[i].fileID,
            minVerticalPadding: 10,
            leading: Image.network(playlist[i].thumbnail),
            title: Text(playlist[i].name, softWrap: false, overflow: TextOverflow.fade),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(playlist[i].createdAt.diffForHuman(), style: const TextStyle(fontSize: 12)),
                  Text(playlist[i].size.toByteString(),style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        });
  }
}
