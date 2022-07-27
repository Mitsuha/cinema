import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hourglass/ali_driver/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AliDriverInitState {
  initialing,
  initialed,
  fail,
}

class AliPersistence with ChangeNotifier {
  static const originHeader = <String, String>{
    'referer': 'https://www.aliyundrive.com/',
    'origin': 'https://www.aliyundrive.com/'
  };

  late String accessToken;
  late String refreshToken;
  late String rootDriver;

  AliDriverInitState initState = AliDriverInitState.initialing;

  static AliPersistence? _instance;

  static AliPersistence get instance => _instance!;

  static Future<AliPersistence> init() async {
    if(_instance != null){
      return _instance!;
    }

    _instance = AliPersistence._internal();

    var sharedPreferences = await SharedPreferences.getInstance();

    String? dbJson = sharedPreferences.getString('DB');
    if (dbJson == null) {
      instance.initState = AliDriverInitState.fail;
      instance.notifyListeners();
      return instance;
    }
    var json = jsonDecode(dbJson);

    if (json['refreshToken'] == '') {
      instance.initState = AliDriverInitState.fail;
      instance.notifyListeners();
      return instance;
    }

    instance.accessToken = json['accessToken'];
    instance.refreshToken = json['refreshToken'];
    instance.rootDriver = json['rootDriver'];

    await AliDriver.refreshToken();

    instance.initState = AliDriverInitState.initialed;
    instance.notifyListeners();

    return instance;
  }

  AliPersistence._internal() {
    Timer.periodic(const Duration(minutes: 30), (_) {
      if (initState == AliDriverInitState.initialed) {
        AliDriver.refreshToken();
      }
    });
  }

  clearLoginStatus() {
    accessToken = '';
    refreshToken = '';
    rootDriver = '';

    initState = AliDriverInitState.fail;
    save();
  }

  save() async {
    var json = jsonEncode({
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'rootDriver': rootDriver,
    });
    notifyListeners();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('DB', json);
  }
}
