import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hourglass/ali_driver/persistence.dart';
import 'package:hourglass/basic.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AliDriverSignIn extends StatefulWidget {
  const AliDriverSignIn({Key? key}) : super(key: key);

  static const singInUrl = 'https://www.aliyundrive.com/sign/in';
  static const defaultAvatar = 'https://gw.alicdn.com/imgextra/i4/O1CN01Zqmj9x1yqaZster4k_!!6000000006630-2-tps-128-128.png';

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

    Timer.periodic(const Duration(seconds: 1), (t){
      _timer = t;
      checkStatus();
    });
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
        userAgent: Basic.userAgent,
        onWebViewCreated: (controller) {
          _controller = controller;
          _controller?.clearCache();
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

    if (url != null && ! url.contains('/drive')) {
      return;
    }

    const code = 'localStorage.getItem("token")';

    _controller!.runJavascriptReturningResult(code).then((value) {
      value = value.replaceAll('\\"', '"');

      var json = jsonDecode(value.substring(1, value.length - 1));

      AliPersistence.instance.accessToken = json['access_token'];
      AliPersistence.instance.refreshToken = json['refresh_token'];
      AliPersistence.instance.rootDriver = json['default_drive_id'];
      AliPersistence.instance.initState = AliDriverInitState.initialed;
      AliPersistence.instance.save();
    });

    _timer!.cancel();
  }
}
