import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hourglass/page/welcome/floating.dart';
import 'package:hourglass/page/welcome/signup.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _AliDriveInitStackState();
}

class _AliDriveInitStackState extends State<Welcome> {
  Timer? _timer;

  @override
  void initState() {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ));
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Material(
      color: Colors.white,
      child: Stack(
        children: [
          const Floating(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: screen.height / 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Image.asset('assets/images/sign_up.png'),
                ),
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('光映', style: TextStyle(fontSize: 50, fontFamily: 'SignupOnly')),
                        SizedBox(height: 6),
                        Text(
                          '无限制的和朋友分享储存在阿里云盘上的任何视频，并同步你们的进度条。',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text('在使用之前需登录你的阿里云盘账号。',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                DecoratedBox(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    gradient: LinearGradient(colors: [Color(0xffaebdeb), Color(0xffbecfff)]),
                  ),
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return const Signup();
                        }));
                      },
                      icon: const Icon(Icons.login),
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                const Text('你的登录信息只会保存在此设备上', style: TextStyle(fontSize: 11, color: Colors.grey))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
