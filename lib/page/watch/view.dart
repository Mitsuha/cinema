import 'package:flutter/material.dart';
import 'package:hourglass/components/player/player.dart';
import 'package:hourglass/model/room.dart';
import 'package:hourglass/page/watch/controller.dart';
import 'package:hourglass/page/watch/interactive.dart';
import 'package:hourglass/page/watch/state.dart';
import 'package:provider/provider.dart';

class WatchPage extends StatefulWidget {
  final Room room;

  const WatchPage({Key? key, required this.room}) : super(key: key);

  @override
  State<WatchPage> createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {
  final WatchController controller = WatchController();
  final playerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    controller.init(widget.room);
  }

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    print('change');

    /// 只更新和 Keyboard 相关的参数
    // if(MediaQuery.of(context).viewInsets.bottom != 0){
    //   state.systemKeyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    //   state.hasAnyKeyboardShow.value = true;
    //   state.systemKeyboardOnShow.value = true;
    //
    //   // 食言了家人们，还得在这儿更新
    //   state.activeSoftKeyboard.value = ActiveSoftKeyboard.none;
    // }else{
    //   // 系统键盘被收起
    //   state.systemKeyboardOnShow.value = false;
    //
    //   if (state.activeSoftKeyboard.value == ActiveSoftKeyboard.none) {
    //     state.hasAnyKeyboardShow.value = false;
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    final Player player = Player(
      key: playerKey,
      controller: controller.player,
    );

    return WillPopScope(
      onWillPop: () => controller.onWillPop(context),
      child: MultiProvider(
        providers: [
          Provider<WatchController>(create: (_) => controller),
          ChangeNotifierProvider<WatchState>(create: (_) => controller.state),
        ],
        child: Material(
          color: Colors.white,
          child: OrientationBuilder(builder: (context, Orientation orientation) {
            if (orientation == Orientation.landscape) {
              return player;
            }
            return Column(
              children: [
                player,
                const Expanded(child: Interactive()),
              ],
            );
          }),
        ),
      ),
    );
  }
}
