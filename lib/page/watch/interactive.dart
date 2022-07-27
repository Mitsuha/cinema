import 'package:flutter/material.dart';
import 'package:hourglass/page/watch/components/chat.dart';
import 'package:hourglass/page/watch/components/playlist.dart';

class Interactive extends StatelessWidget {
  const Interactive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Column(
        children: const [
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFD6D6D6), width: .2))
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 130,
                height: 30,
                child: TabBar(
                  labelColor: Colors.black,
                    padding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.zero,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                  Tab(child: Text('聊天')),
                  Tab(child: Text('播放列表')),
                ]),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
            physics: BouncingScrollPhysics(),
                children: [
              WatchChat(),
              WatchPlayList(),
            ]),
          )
        ],
      ),
    );
  }
}
