import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hourglass/ali_driver/persistence.dart';
import 'package:hourglass/basic.dart';
import 'package:hourglass/page/welcome/floating.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Signup extends StatelessWidget {
  static const signInUrl =
      'https://auth.aliyundrive.com/v2/oauth/authorize?client_id=25dzX3vbYqktVxyX&redirect_uri=https%3A%2F%2Fwww.aliyundrive.com%2Fsign%2Fcallback&response_type=code&login_type=custom&state=%7B%22origin%22%3A%22https%3A%2F%2Fwww.aliyundrive.com%22%7D#/nestedlogin?keepLogin=false&hidePhoneCode=true&ad__pass__q__rememberLogin=true&ad__pass__q__rememberLoginDefaultValue=true&ad__pass__q__forgotPassword=true&ad__pass__q__licenseMargin=true&ad__pass__q__loginType=normal';

  static const defaultAvatar =
      'https://gw.alicdn.com/imgextra/i4/O1CN01Zqmj9x1yqaZster4k_!!6000000006630-2-tps-128-128.png';

  static const _hookPostMessage = '''
  function getLoginInfo(){
    console.log('registered')
    var COOKIE_KEY_DEVICE_ID = 'cna';
    var query = getQueryValues();
    var code = query.code;
    var state = query.state;
    var keep = query.keep;
    var loginType = query.loginType || undefined;
    var deviceId = query.deviceId || getCookieByKey(COOKIE_KEY_DEVICE_ID);
    var deviceName = query.deviceName || undefined;
    var modelName = query.modelName || undefined;
    var params = {
      code,
      loginType,
      deviceId,
      deviceName,
      modelName
    };
  
    getTokenInfo(params, function (err, tokenInfo) {
        if (err) {
            showError(err.message);
            FlutterLogin.postMessage(JSON.stringify({"error": true, "message": err.message}))
        } else {
          FlutterLogin.postMessage(JSON.stringify(tokenInfo))
        }
    });
  }
  
  getLoginInfo();
  ''';

  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    WebViewController? controller;

    return Material(
      color: const Color(0xffecefff),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Floating(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100, bottom: 15),
                child: SizedBox(
                  width: 216,
                  child: Image.asset('assets/images/aliDrive.png'),
                ),
              ),
              LayoutBuilder(
                builder: (context, BoxConstraints constraints) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: constraints.maxWidth <= 360 ? 0: 20),
                    child: Transform.scale(
                      scale: constraints.maxWidth <= 360 ? 0.83: 1,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        child: SizedBox(
                          width: 360,
                          height: 350,
                          child: WebView(
                            initialUrl: Signup.signInUrl,
                            javascriptMode: JavascriptMode.unrestricted,
                            userAgent: Basic.userAgent,
                            onWebViewCreated: (c) => controller = c..clearCache(),
                            javascriptChannels: {
                              JavascriptChannel(
                                  name: 'FlutterLogin',
                                  onMessageReceived: (JavascriptMessage message) {
                                    var msg = jsonDecode(message.message);

                                    AliPersistence.instance.accessToken = msg['access_token'];
                                    AliPersistence.instance.refreshToken = msg['refresh_token'];
                                    AliPersistence.instance.rootDriver = msg['default_drive_id'];
                                    AliPersistence.instance.initState = AliDriverInitState.initialed;
                                    AliPersistence.instance.save();
                                    Navigator.of(context).pop();
                                  })
                            },
                            onPageFinished: (s) {
                              controller!.runJavascript(Signup._hookPostMessage);
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }
              ),
              const Text('你的登录信息只会保存在此设备上', style: TextStyle(color: Colors.grey))
            ],
          ),
        ],
      ),
    );
  }
}
