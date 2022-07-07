import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hourglass/model/db.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AliDriverSignIn extends StatefulWidget {
  const AliDriverSignIn({Key? key}) : super(key: key);

  static const singInUrl = 'https://www.aliyundrive.com/sign/in';
  static const userAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.53 Safari/537.36 Edg/103.0.1264.37';

  @override
  State<AliDriverSignIn> createState() => _AliDriveInitStackState();
}

class _AliDriveInitStackState extends State<AliDriverSignIn> {
  WebViewController? _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) WebView.platform = AndroidWebView();

    _timer = Timer(const Duration(seconds: 1), checkStatus);
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login ali Drive'),
      ),
      body: WebView(
        initialUrl: AliDriverSignIn.singInUrl,
        javascriptMode: JavascriptMode.unrestricted,
        userAgent: AliDriverSignIn.userAgent,
        onWebViewCreated: (controller) {
          _controller = controller;
        },
        navigationDelegate: (navigation) {
          if (navigation.url.contains('/protocol') ||
              navigation.url.contains('/protocol')) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('请在本页登录账号'),
              duration: Duration(seconds: 1),
            ));

            return NavigationDecision.prevent;
          }

          return NavigationDecision.navigate;
        },
      ),
      floatingActionButton: Column(
        children: [
          const Expanded(child: SizedBox()),
          FloatingActionButton(
            onPressed: () {
              _controller!.clearCache().then((_) {
                _controller!.loadUrl(AliDriverSignIn.singInUrl);
              });
            },
            tooltip: 'Refresh',
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  void checkStatus() async {
    var url = await _controller?.currentUrl();

    if (url != null && url.contains('/drive/')) {
      return;
    }

    const code = 'localStorage.getItem("token")';

    _controller!.runJavascriptReturningResult(code).then((value) {
      value = value.replaceAll('\\"', '"');

      var json = jsonDecode(value.substring(1, value.length - 1));

      DB.name = json['nick_name'];
      DB.avatar = json['avatar'];
      DB.accessToken = json['access_token'];
      DB.refreshToken = json['refresh_token'];
      DB.rootDriver = json['default_drive_id'];
      DB.phone = json['user_name'];

      DB.initNotifier.value = false;
      DB.initNotifier.value = true;
    });

    _timer!.cancel();
  }
}
