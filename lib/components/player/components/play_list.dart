import 'package:flutter/material.dart';
import 'package:hourglass/components/player/controller.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:provider/provider.dart';

class VideoPlayList extends StatefulWidget {
  const VideoPlayList({Key? key}) : super(key: key);

  @override
  State<VideoPlayList> createState() => _VideoPlayListState();
}

class _VideoPlayListState extends State<VideoPlayList> {
  final _scrollController = ScrollController();
  late PlayerController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var state = context.read<PlayerState>();

      final index = state.playlist.indexWhere((e) => state.currentEpisode == e);

      _scrollController.jumpTo(index * 18 * 2);
    });
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller = context.read<PlayerController>();
    PlayerState state = context.watch<PlayerState>();

    print('build');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(13, 20, 0, 13),
          child: Text(
            '选集',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: state.playlist.length,
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            itemBuilder: (BuildContext context, int i) {
              bool active = state.currentEpisode == state.playlist[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 2),
                child: InkWell(
                  radius: 6,
                  onTap: _controller.canControl ? () => _controller.selectEpisode(i) : null,
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
                        softWrap: false,
                        overflow: TextOverflow.fade,
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
