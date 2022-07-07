// import 'package:hourglass/model/user.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class DB{
//   User? user;
//
//   static DB ?_instance;
//
//   DB._internal({required this.user});
//
//   static static get instance async {
//     if (_instance == null){
//       var pre = await SharedPreferences.getInstance();
//
//     }
//
//     return _instance!;
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DB {
  static const String defaultAvatar = 'https://gw.alicdn.com/imgextra/i4/O1CN01Zqmj9x1yqaZster4k_!!6000000006630-2-tps-128-128.png';

  static SharedPreferences? _prefs;

  static final Map<String, dynamic> _cache = {};

  static ValueNotifier<bool> initNotifier = ValueNotifier(false);

  static init() {
    SharedPreferences.getInstance().then((value) {
      _prefs = value;

      initNotifier.value = true;
    });
  }

  static get name {
    if (_cache['name'] == null) {
      _cache['name'] = _prefs?.getString('name');
    }
    return _cache['name'];
  }

  static set name(v) {
    _cache['name'] = v;
    _prefs!.setString('name', v);
  }

  static get avatar {
    if (_cache['avatar'] == null) {
      _cache['avatar'] = _prefs?.getString('avatar');
    }
    return _cache['avatar'];
  }

  static set avatar(v) {
    _cache['avatar'] = v;
    _prefs!.setString('avatar', v);
  }

  static get accessToken {
    if (_cache['accessToken'] == null) {
      _cache['accessToken'] = _prefs?.getString('accessToken');
    }
    return _cache['accessToken'];
  }

  static set accessToken(v) {
    _cache['accessToken'] = v;
    _prefs!.setString('accessToken', v);
  }

  static get refreshToken {
    if (_cache['refreshToken'] == null) {
      _cache['refreshToken'] = _prefs?.getString('refreshToken');
    }
    return _cache['refreshToken'];
  }

  static set refreshToken(v) {
    _cache['refreshToken'] = v;
    _prefs!.setString('refreshToken', v);
  }

  static get rootDriver {
    if (_cache['rootDriver'] == null) {
      _cache['rootDriver'] = _prefs?.getString('rootDriver');
    }
    return _cache['rootDriver'];
  }

  static set rootDriver(v) {
    _cache['rootDriver'] = v;
    _prefs!.setString('rootDriver', v);
  }

  static get phone {
    if (_cache['phone'] == null) {
      _cache['phone'] = _prefs?.getString('phone');
    }
    return _cache['phone'];
  }

  static set phone(v) {
    _cache['phone'] = v;
    _prefs!.setString('phone', v);
  }
}
