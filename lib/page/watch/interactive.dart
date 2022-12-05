import 'package:flutter/material.dart';
import 'package:hourglass/page/watch/components/chat.dart';
import 'package:hourglass/page/watch/components/playlist.dart';
import 'package:hourglass/page/watch/state.dart';
import 'package:provider/provider.dart';

class Interactive extends StatefulWidget {
  const Interactive({Key? key}) : super(key: key);

  @override
  State<Interactive> createState() => _InteractiveState();
}

class _InteractiveState extends State<Interactive> with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    context.read<WatchState>().tabController = tabController;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 150,
            height: 38,
            child: TabBar(
              labelColor: Colors.white,
              padding: EdgeInsets.zero,
              labelPadding: EdgeInsets.zero,
              indicatorSize: TabBarIndicatorSize.label,
              controller: tabController,
              indicator: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xff6c24a2), width: 2))
              ),
              tabs: const [Tab(child: Text('聊天')), Tab(child: Text('播放列表'))],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: const [WatchChat(), WatchPlayList()],
          ),
        )
      ],
    );
  }
}
