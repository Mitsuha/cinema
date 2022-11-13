import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hourglass/page/homepage/components/card_item.dart';
import 'package:hourglass/page/homepage/controller.dart';
import 'package:provider/provider.dart';

class HomepageMenu extends StatelessWidget {
  static const double iconSize = 46;

  const HomepageMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomepageController controller = context.read<HomepageController>();

    return Material(
      color: Colors.transparent,
      child: Column(children: [
        Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(3.9),
            onTap: controller.showFileSelector,
            child: CardItem(
              icon: Image.asset('assets/images/watch.png', width: iconSize),
              title: '创建房间',
              subtitle: '选一段视频和朋友一起看吧',
            ),
          ),
        ),
        InkWell(
          onTap: () =>
              showDialog(context: context, builder: (ctx) => buildJoinDialog(ctx, controller)),
          child: CardItem(
            icon: Transform.translate(
              offset: const Offset(-5, 0),
              child: Image.asset('assets/images/get_in.png', width: iconSize),
            ),
            title: '加入',
            subtitle: '已经创建好了房间？选这里',
          ),
        ),
        CardItem(
          icon: Transform.translate(
            offset: const Offset(-5, 0),
            child: Image.asset('assets/images/setting.png', width: iconSize),
          ),
          title: '设置',
          subtitle: '没什么好设置的',
        ),
        CardItem(
          icon: Transform.translate(
            offset: const Offset(-5, 0),
            child: Image.asset('assets/images/give.png', width: iconSize),
          ),
          title: '赞赏',
          subtitle: '给你认为不错的应用鼓励，这很健康',
        ),
      ]),
    );
  }

  Widget buildJoinDialog(BuildContext context, HomepageController controller) {
    String roomID = '';

    return AlertDialog(
      title: const Text('有人在等你？输入你们的暗号~'),
      content: TextField(
        decoration: const InputDecoration(hintText: '房间号'),
        keyboardType: TextInputType.number,
        onChanged: (value) => roomID = value,
      ),
      actions: [
        TextButton(
          child: const Text('取消', style: TextStyle(color: Colors.grey)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('加入'),
          onPressed: () async {
            try {
              controller.getRoomInfo(int.parse(roomID)).then((room) {
                if (room == null) {
                  Fluttertoast.showToast(msg: '要加入的房间不存在');
                } else {
                  controller.joinRoom(context, room);

                  Navigator.of(context).pop();
                }
              });
            } catch (_) {
              Fluttertoast.showToast(msg: '要加入的房间不存在');
            }
          },
        ),
      ],
    );
  }
}
