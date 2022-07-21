import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller.init();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      controller.onAppResumed(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.onAppResumed(context);

    return MultiProvider(
      providers: [
        Provider<HomepageController>(create: (_) => controller),
        ChangeNotifierProvider<HomepageState>(create: (_) => controller.state)
      ],
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 30, 28, 10),
                child: Column(
                  children: const [UserProfile(), SizedBox(height: 5), HomepageMenu()],
                ),
              ),
            ),
            Consumer<HomepageState>(builder: (context, state, _) {
              if (!state.fileSelectorVisible) {
                return const SizedBox();
              }
              return Positioned.fill(
                child: AnimatedOpacity(
                  duration: Basic.animationDuration,
                  opacity: state.fileSelectorShow ? 1 : 0,
                  onEnd: () => state.setFileSelectorVisible(false),
                  child: ColoredBox(
                    color: const Color(0x50000000),
                    child: GestureDetector(onTap: controller.hiddenFileSelector),
                  ),
                ),
              );
            }),
            Consumer<HomepageState>(builder: (context, state, _) {
              var height = MediaQuery.of(context).size.height / 1.5;

              return AnimatedPositioned(
                duration: Basic.animationDuration,
                bottom: state.fileSelectorShow ? 0 : -height,
                right: 0,
                child: const FileSelector(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
