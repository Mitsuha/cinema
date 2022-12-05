import 'package:flutter/material.dart';
import 'package:hourglass/ali_driver/persistence.dart';
import 'package:hourglass/page/welcome_page.dart';
import 'package:hourglass/runtime.dart';
import 'package:provider/provider.dart';

void main() {
  /// todo: https://github.com/rrousselGit/provider/issues/356
  Provider.debugCheckInvalidValueType = null;
  // WidgetsFlutterBinding.ensureInitialized();

  Runtime.boot();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AliPersistence.init(),
        lazy: false,
        builder: (context, _) {
          return MaterialApp(
            title: 'Hourglass',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const WelcomePage(),
          );
        }
    );
  }
}
