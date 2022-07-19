import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hourglass/basic.dart';
import 'package:hourglass/model/room.dart';
import 'package:hourglass/model/user.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';

class Ws {
  static Ws? _instance;

  static Ws get instance => _instance!;
  static bool connecting = false;

  IOWebSocketChannel channel;
  bool registered = false;
  User? user;
  Room? room;
  StreamController stream = StreamController<Map<String, dynamic>>.broadcast();

  static Ws connect() {
    return _instance ??= Ws._internal(_getWsConnect());
  }

  static IOWebSocketChannel _getWsConnect() {
    return IOWebSocketChannel.connect(Uri.parse(Basic.remoteAddress));
  }

  Ws._internal(this.channel) {
    channel.stream.listen(distribution,
        onError: (err) {
          reconnect();
        },
        onDone: () => reconnect());
  }

  reconnect() {
    if (connecting) {
      return;
    }

    connecting = true;
    Fluttertoast.showToast(msg: '断线重连中...');

    Future.delayed(const Duration(seconds: 3)).then((_) {
      channel = _getWsConnect()
        ..stream.listen(distribution, onError: (err) {
          if (kDebugMode) {
            print('err');
            print(err);
          }
          reconnect();
        }, onDone: () {
          reconnect();
        });

      if (user != null) {
        register(user!);
      }
      connecting = false;
    });
  }

  distribution(event) {
    print('distribution: $event');
    stream.add(jsonDecode(event));
  }

  register(User user) {
    this.user = user;
    channel.sink.add(jsonEncode({
      'event': 'register',
      'payload': user.toJson()
    }));
  }

  logout() {
    user = null;
    channel.sink.add(jsonEncode({
      "event": "logout",
    }));
  }

  Future<Map<String, dynamic>> request (String event, Map<String, dynamic> payload) async {
    var id = const Uuid().v4().toString();
    channel.sink.add(jsonEncode({
      'event': event,
      'id': id,
      'payload': payload
    }));

    await for (var msg in stream.stream) {
      if (msg['event'] == 'reply' && msg['id'] == id) {
        return msg;
      }
    }

    return {};
  }

  Future<Map<String, dynamic>> createRoom() async {
    return request('createRoom', {});
  }
}