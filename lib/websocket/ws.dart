import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hourglass/ali_driver/persistence.dart';
import 'package:hourglass/basic.dart';
import 'package:web_socket_channel/io.dart';

class Ws {
  static Ws? _instance;

  static Ws get instance => _instance!;

  IOWebSocketChannel channel;
  bool registered = false;

  static Ws connect() {
    return _instance ??= Ws._internal(_getWsConnect());
  }

  static IOWebSocketChannel _getWsConnect() {
    return IOWebSocketChannel.connect(Uri.parse(Basic.remoteAddress));
  }

  Ws._internal(this.channel) {
    channel.stream.listen(null, onError: (err) {
      reconnect();
    });
  }

  reconnect() {
    channel = _getWsConnect()
      ..stream.listen(null, onError: (err) {
        if (kDebugMode) {
          print(err);
        }
        reconnect();
      });
  }

  register() {
    print('send');
  }

  logout(){

  }
}
