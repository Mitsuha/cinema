import 'package:flutter/material.dart';
import 'package:hourglass/model/db.dart';
import 'package:hourglass/page/ali_drive_sing_in.dart';
import 'package:hourglass/page/homepage/homepage.dart';
import 'package:hourglass/page/welcome_page.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  DB.init();

  runApp(const MyApp());
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
      home: ValueListenableBuilder(
        valueListenable: DB.initNotifier,
        builder: (BuildContext context, value, Widget? _){
          if(value == false) {
            return const WelcomePage();
          }

          if(DB.accessToken == null){
            return const AliDriverSignIn();
          }
          return const Homepage();
        },
      ),
    );
  }
}
