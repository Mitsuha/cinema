import 'package:flutter/material.dart';
import 'package:hourglass/ali_driver/persistence.dart';
import 'package:hourglass/page/ali_drive_sing_in.dart';
import 'package:hourglass/page/homepage/homepage.dart';
import 'package:hourglass/page/welcome_page.dart';
import 'package:hourglass/websocket/ws.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  /// todo: https://github.com/rrousselGit/provider/issues/356
  Provider.debugCheckInvalidValueType = null;
  Ws.connect();

  runApp(Ws.warp(
    child: AliPersistence.warp(
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hourglass',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Consumer<AliPersistence>(
        builder: (BuildContext context, db, _) {
          if (db.initState == AliDriverInitState.initialing) {
            return const WelcomePage();
          }

          if (db.initState == AliDriverInitState.fail) {
            return const AliDriverSignIn();
          }

          return Homepage();
        },
      ),
    );
  }
}
