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

  static AliPersistence init() {
    return _instance ??= AliPersistence._internal();
  }

  static AliPersistence get instance => _instance!;

  AliPersistence._internal() {
    SharedPreferences.getInstance().then((SharedPreferences sharedPreferences) async {
      String? db = sharedPreferences.getString('DB');
      if (db == null) {
        initState = AliDriverInitState.fail;
        notifyListeners();
        return;
      }
      var json = jsonDecode(db);

      if (json['refreshToken'] == '') {
        initState = AliDriverInitState.fail;
        notifyListeners();
        return;
      }

      accessToken = json['accessToken'];
      refreshToken = json['refreshToken'];
      rootDriver = json['rootDriver'];

      await AliDriver.refreshToken();

      initState = AliDriverInitState.initialed;
      notifyListeners();
    });

    Timer.periodic(const Duration(minutes: 30), (t) => AliDriver.refreshToken());
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
