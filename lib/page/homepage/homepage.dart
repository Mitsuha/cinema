import 'package:flutter/material.dart';
import 'package:hourglass/page/homepage/components/card_item.dart';
import 'package:hourglass/page/homepage/components/header.dart';
import 'package:hourglass/page/homepage/components/selector.dart';
import 'package:hourglass/page/homepage/controller.dart';

class Homepage extends StatefulWidget {
  static const double iconSize = 46;
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    HomepageController.getInstance().loadFile();

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 30, 28, 10),
              child: options(),
            ),
          ),
          const Positioned.fill(child: ColoredBox(color: Color(0x4D000000))),
          const Positioned(child: VideoSelector())
        ],
      ),
    );
  }

  Widget options() => Column(
        children: [
          const Header(),
          const SizedBox(height: 3),
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(3.9),
              onTap: () {},
              child: CardItem(
                icon: Image.asset('assets/images/watch.png', width: Homepage.iconSize),
                title: '创建房间',
                subtitle: '选择一段视频和朋友一起看吧',
              ),
            ),
          ),
          CardItem(
            icon: Transform.translate(
              offset: const Offset(-5, 0),
              child: Image.asset('assets/images/get_in.png', width: Homepage.iconSize),
            ),
            title: '加入',
            subtitle: '已经创建好了房间？选这里',
          ),
          CardItem(
            icon: Transform.translate(
              offset: const Offset(-5, 0),
              child: Image.asset('assets/images/setting.png', width: Homepage.iconSize),
            ),
            title: '设置',
            subtitle: '没什么好设置的',
          ),
          CardItem(
            icon: Transform.translate(
              offset: const Offset(-5, 0),
              child: Image.asset('assets/images/give.png', width: Homepage.iconSize),
            ),
            title: '赞赏',
            subtitle: '给你认为不错的应用鼓励，这很健康',
          ),
        ],
      );
}
