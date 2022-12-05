import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/basic.dart';
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

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 10),
      addAutomaticKeepAlives: true,
      itemCount: controller.player.playList.length + 1,
      itemBuilder: (BuildContext context, int i) {
        if (i == controller.player.playList.length) {
          if(! state.isOwner){
            return const SizedBox();
          }
          return IconButton(onPressed: () {}, icon: const Icon(Icons.add));
        }
        return _PlaylistItem(
          state: state,
          controller: controller,
          file: controller.player.playList[i],
          index: i,
        );
      },
    );
  }
}

class _PlaylistItem extends StatefulWidget {
  final int index;
  final AliFile file;
  final WatchState state;
  final WatchController controller;

  const _PlaylistItem(
      {required this.index,
      Key? key,
      required this.state,
      required this.controller,
      required this.file})
      : super(key: key);

  @override
  State<_PlaylistItem> createState() => _PlaylistItemState();
}

class _PlaylistItemState extends State<_PlaylistItem> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var current = widget.controller.player.currentEpisode;

    return ListTile(
      selected: current?.fileID == widget.file.fileID,
      minVerticalPadding: 10,
      textColor: Colors.white,
      selectedColor: const Color(0xff9271d8),
      leading: Image.network(
        widget.file.thumbnail,
        headers: Basic.originHeader,
        errorBuilder: (_, __, ___) => Image.network(Basic.fullbackImage),
      ),
      title: Text(widget.file.name, softWrap: false, overflow: TextOverflow.fade),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 10.0, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.file.createdAt.diffForHuman(), style: const TextStyle(fontSize: 12)),
            Text(widget.file.size.toByteString(), style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
      onTap: () {
        if (!widget.state.isOwner) {
          Fluttertoast.showToast(msg: '你不是房主无法选集');
        } else {
          widget.controller.selectEpisode(widget.index);
        }
      },
    );
  }
}
