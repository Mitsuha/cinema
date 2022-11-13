import 'dart:io';
import 'package:flutter/foundation.dart';

class Basic {
  static const originHeader = <String, String>{
    'referer': 'https://www.aliyundrive.com/',
    'origin': 'https://www.aliyundrive.com/'
  };

  static const userAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.53 Safari/537.36 Edg/103.0.1264.37';

  static const fullbackImage =
      'https://img.alicdn.com/imgextra/i2/O1CN01ROG7du1aV18hZukHC_!!6000000003334-2-tps-140-140.png';

  static String get remoteAddress {
    // return 'ws://39.106.38.232:3096/ws';

    if(kReleaseMode){
      return 'ws://39.106.38.232:3096/ws';
    }
    if(Platform.localeName == "zh_CN"){
      return "ws://172.29.240.209:3096/ws";
    }
    return "ws://192.168.124.12:3096/ws";
  }

  static const animationDuration = Duration(milliseconds: 150);
}
