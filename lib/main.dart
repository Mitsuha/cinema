import 'package:flutter/material.dart';
import 'package:hourglass/page/welcome_page.dart';
import 'package:provider/provider.dart';

void main() {
  /// todo: https://github.com/rrousselGit/provider/issues/356
  Provider.debugCheckInvalidValueType = null;

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
      home: const WelcomePage(),
    );
  }
}
