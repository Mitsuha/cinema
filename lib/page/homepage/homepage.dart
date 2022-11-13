import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hourglass/basic.dart';
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

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark
    ));

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      controller.onAppResumed(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<HomepageController>(create: (_) => controller),
        ChangeNotifierProvider<HomepageState>(create: (_) => controller.state)
      ],
      child: Consumer<HomepageState>(
        builder: (context, state, _) {
          final screenSize = MediaQuery.of(context).size;

          return WillPopScope(
            onWillPop: () async {
              if(state.fileSelectorShow){
                state.setFileSelectorShow(false);
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
                  decoration:  BoxDecoration(
                    gradient: RadialGradient(
                      colors: const [Color(0xffdbf4fd), Color(0xffe7f3fe), Colors.white],
                      stops: const [0.1,0.3,1],
                      center: Alignment.topLeft,
                      radius: screenSize.height/500
                    )
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(28, 30, 28, 10),
                      child: Column(
                        children: const [UserProfile(), SizedBox(height: 5), HomepageMenu()],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    ignoring: ! state.fileSelectorShow,
                    child: AnimatedOpacity(
                      duration: Basic.animationDuration,
                      opacity: state.fileSelectorShow ? 1 : 0,
                      child: ColoredBox(
                        color: const Color(0x80000000),
                        child: GestureDetector(onTap: controller.hiddenFileSelector),
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: Basic.animationDuration,
                  bottom: state.fileSelectorShow ? 0 : -screenSize.height / 1.5,
                  right: 0,
                  child: const FileSelector(),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}
