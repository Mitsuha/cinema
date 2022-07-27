import 'package:flutter/material.dart';
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
    AliPersistence.init().then((instance) {
      currentInitState = instance.initState;

      if (mounted && instance.initState == AliDriverInitState.initialed) {
        setState(() {});
      }

      instance.addListener(() {
        if (instance.initState != currentInitState) {
          setState(() => currentInitState = instance.initState);
        }
      });
    });

    Ws.connect();
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
