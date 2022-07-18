import 'package:flutter/material.dart';
import 'package:hourglass/ali_driver/persistence.dart';
import 'package:hourglass/basic.dart';
import 'package:web_socket_channel/io.dart';

class Ws{
  static Ws? _instance;
  static Ws get instance => _instance!;

  IOWebSocketChannel channel;
  bool registered = false;
  Ws._internal(this.channel);

  static connect() {
    _instance ??= Ws._internal(IOWebSocketChannel.connect(Uri.parse(Basic.remoteAddress))..stream.listen((event) {
      print(event);
    },onError: (e){
      print(e);
    }));
  }

  static Widget warp({required Widget child}){
    AliPersistence.instance.addListener(() {
      if(instance.registered == false && AliPersistence.instance.initState == AliDriverInitState.initialed){
        instance.register();
      }
    });
    return child;
  }

  register(){
    print('send');
  }

}