import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hourglass/basic.dart';
import 'package:hourglass/model/room.dart';
import 'package:hourglass/page/homepage/components/menu.dart';
import 'package:hourglass/page/homepage/components/profile.dart';
import 'package:hourglass/page/homepage/components/selector.dart';
import 'package:hourglass/page/homepage/state.dart';
import 'package:hourglass/page/homepage/controller.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with WidgetsBindingObserver {
  final controller = HomepageController();
  DateTime _lastTapBack = DateTime.now();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    controller.init();

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark));

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      log(state.toString());
      var room = await controller.getRoomInfoFromClipboard();

      if (room != null) {
        log(room.toJson().toString());
        showDialog(
          context: context,
          builder: (ctx) => buildJoinAlertDialog(ctx, room),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return MultiProvider(
      providers: [
        Provider<HomepageController>(create: (_) => controller),
        ChangeNotifierProvider<HomepageState>(create: (_) => controller.state),
        ChangeNotifierProvider<FileSelectorState>(create: (_) => controller.fileSelector)
      ],
      child: WillPopScope(
        onWillPop: () async {
          if (controller.fileSelector.isShow) {
            controller.fileSelector.hidden();
            return false;
          }
          if (DateTime.now().difference(_lastTapBack) > const Duration(seconds: 1)) {
            _lastTapBack = DateTime.now();
            Fluttertoast.showToast(msg: '再按一次退出');
            return false;
          }
          return true;
        },
        child: Stack(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                  gradient: RadialGradient(
                      colors: const [Color(0xffdbf4fd), Color(0xffe7f3fe), Colors.white],
                      stops: const [0.1, 0.3, 1],
                      center: Alignment.topLeft,
                      radius: screenSize.height / 500)),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 30, 28, 10),
                  child: Column(
                    children: const [UserProfile(), SizedBox(height: 5), HomepageMenu()],
                  ),
                ),
              ),
            ),
            const FileSelectorDialog(),
          ],
        ),
      ),
    );
  }

  Widget buildJoinAlertDialog(BuildContext context, Room room) {
    return Dialog(
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  room.currentPlay.thumbnail,
                  headers: Basic.originHeader,
                  loadingBuilder: (_,__,___,)=> Image.asset('assets/images/cinema.png'),
                  errorBuilder: (_,__,___,)=> Image.asset('assets/images/cinema.png'),
                ),
                const Positioned.fill(child: ColoredBox(color: Colors.black26)),
                DefaultTextStyle(
                  style: const TextStyle(color: Colors.white),
                  child: Column(
                    children: [
                      const Icon(Icons.play_circle_outline, color: Colors.white, size: 50),
                      const SizedBox(height: 10),
                      const Text('正在播放'),
                      Text(room.currentPlay.name),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: DialogTheme.of(context).actionsPadding ?? const EdgeInsets.all(3 + 1),
              child: OverflowBar(
                alignment: MainAxisAlignment.end,
                spacing: 8,
                children: [
                  TextButton(
                    child: const Text('取消', style: TextStyle(color: Colors.grey)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: const Text('加入'),
                    onPressed: () {
                      var navigator = Navigator.of(context);

                      navigator.pop();

                      controller.joinRoom(navigator, room);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FileSelectorDialog extends StatelessWidget {
  const FileSelectorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FileSelectorState>();
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !state.isShow,
            child: AnimatedOpacity(
              duration: Basic.animationDuration,
              opacity: state.isShow ? 1 : 0,
              child: ColoredBox(
                color: const Color(0x80000000),
                child: GestureDetector(onTap: () => state.hidden()),
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: Basic.animationDuration,
          curve: Curves.easeOut,
          bottom: state.isShow ? 0 : -screenSize.height / 1.5,
          right: 0,
          child: const FileSelector(),
        )
      ],
    );
  }
}
