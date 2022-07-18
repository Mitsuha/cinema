import 'package:flutter/material.dart';
import 'package:hourglass/ali_driver/api.dart';
import 'package:hourglass/ali_driver/persistence.dart';
import 'package:hourglass/page/ali_drive_sing_in.dart';
import 'package:hourglass/websocket/ws.dart';

import 'homepage/homepage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  AliDriverInitState currentInitState = AliDriverInitState.initialing;

  @override
  void initState() {
    super.initState();

    listenState();
  }

  listenState() async {
    var ali = await AliPersistence.init();

    Ws.connect();

    if (ali.initState == AliDriverInitState.initialed) {
      Ws.instance.register();
      currentInitState = ali.initState;
      if (mounted) {
        setState(() {});
      }
    }

    ali.addListener(() {
      // 加载成功 => 注册
      if (ali.initState == AliDriverInitState.initialed && currentInitState != ali.initState) {
        Ws.instance.register();
      }
      // 从加载成功变为加载失败 => 登出
      if (ali.initState == AliDriverInitState.fail && currentInitState == AliDriverInitState.initialed) {
        Ws.instance.logout();
      }

      if (ali.initState != currentInitState) {
        setState(() => currentInitState = ali.initState);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentInitState == AliDriverInitState.fail) {
      return const AliDriverSignIn();
    }

    if (currentInitState == AliDriverInitState.initialed) {
      return const Homepage();
    }

    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text('少女祈祷中...'),
      ),
    );
  }
}
