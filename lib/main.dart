import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hourglass/model/db.dart';
import 'package:hourglass/page/ali_drive_sing_in.dart';
import 'package:hourglass/page/homepage/homepage.dart';
import 'package:hourglass/page/welcome_page.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final videoLoadedNotifier = ValueNotifier(false);

  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) WebView.platform = AndroidWebView();

    _videoPlayerController = VideoPlayerController.network(
        'https://tup.yinghuacd.com/cache/Youzitsu201.m3u8')
      ..initialize().then((value) => videoLoadedNotifier.value = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: videoLoadedNotifier,
        builder: (BuildContext context, loaded, Widget? _) {
          if (!(loaded as bool)) {
            return const Center(child: CircularProgressIndicator());
          }

          return AspectRatio(
            aspectRatio: _videoPlayerController!.value.aspectRatio,
            child: VideoPlayer(_videoPlayerController!),
          );
        },
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: videoLoadedNotifier,
        builder: (BuildContext context, loaded, Widget? _) {
          return FloatingActionButton(
            child: Icon(_videoPlayerController!.value.isPlaying
                ? Icons.pause
                : Icons.play_arrow),
            onPressed: () {

              _videoPlayerController!.value.isPlaying
                  ? _videoPlayerController!.pause()
                  : _videoPlayerController!.play();
            },
          );
        },
      ),
    );
  }
}
