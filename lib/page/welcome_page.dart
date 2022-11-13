import 'package:flutter/material.dart';
import 'package:hourglass/ali_driver/persistence.dart';
import 'package:hourglass/page/welcome/welcome.dart';
import 'package:hourglass/websocket/ws.dart';
import 'package:provider/provider.dart';

import 'homepage/homepage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();

    Ws.connect();
  }

  @override
  Widget build(BuildContext context) {
    var persistence = context.watch<AliPersistence>();

    if (persistence.initState == AliDriverInitState.initialing) {
      return const Material(
        color: Colors.white,
        child: Center(
          child: Text('少女祈祷中...'),
        ),
      );
    }

    if (persistence.initState == AliDriverInitState.fail) {
      return const Welcome();
    }

    return const Homepage();
  }
}
