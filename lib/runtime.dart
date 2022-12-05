import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hourglass/model/user.dart';
import 'package:hourglass/websocket/message_bag.dart';
import 'package:hourglass/websocket/distributor.dart';

class Runtime {
  static Runtime? _instance;

  static Runtime get instance => _instance ??= Runtime._internal();

  static void boot() => Runtime.instance;

  static bool _booted = false;

  bool newVersionChecked = false;

  // 全局变量
  User? user;

  Runtime._internal() {
    bootstrap();

    _booted = true;
  }

  void bootstrap() async {
    if (_booted) {
      return;
    }

    /// 沉浸式导航栏
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    }

    /// 全局 ws 连接
    Distributor.instance.listen('disconnect', (_) {
      Fluttertoast.showToast(msg: '断线重连中...');
    });

    /// 维护登录状态
    Distributor.instance.listen('connect', (_) {
      if (user != null) {
        Distributor.instance.emit(SignupMessage(user: user!));
      }
    });
  }
}
