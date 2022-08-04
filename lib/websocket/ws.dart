import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hourglass/ali_driver/models/file.dart';
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
  StreamController broadcast = StreamController<Map<String, dynamic>>.broadcast();

  static Ws connect() {
    return _instance ??= Ws._internal(_getWsConnect());
  }

  static IOWebSocketChannel _getWsConnect() {
    return IOWebSocketChannel.connect(Uri.parse(Basic.remoteAddress));
  }

  Ws._internal(this.channel) {
    channel.stream.listen(distribution, onError: onError, onDone: onDone);
  }

  onError(err) => reconnect();

  onDone() => reconnect();

  reconnect() {
    if (connecting) {
      return;
    }

    connecting = true;
    Fluttertoast.showToast(msg: '断线重连中...');

    Future.delayed(const Duration(seconds: 3)).then((_) {
      channel = _getWsConnect()..stream.listen(distribution, onError: onError, onDone: onDone);

      if (user != null) {
        register(user!);
      }
      if (room != null) {
        joinRoom(room!);
      }
      connecting = false;
    });
  }

  distribution(event) {
    if (kDebugMode) {
      print('distribution: $event');
    }
    broadcast.add(jsonDecode(event));
  }

  Future<Map<String, dynamic>> request(String event, payload) async {
    var id = const Uuid().v4().toString();
    channel.sink.add(jsonEncode({'event': event, 'id': id, 'payload': payload}));

    await for (var msg in broadcast.stream) {
      if (msg['event'] == 'reply' && msg['id'] == id) {
        return msg;
      }
    }

    return {};
  }

  Future<Map<String, dynamic>> createRoom(List<AliFile> playlist) async {
    return request('createRoom', [for (var p in playlist) p.toJson()]);
  }

  register(User user) {
    this.user = user;
    channel.sink.add(jsonEncode({'event': 'register', 'payload': user.toJson()}));
  }

  logout() {
    user = null;
    channel.sink.add(jsonEncode({"event": "logout"}));
  }

  Future<Map<String, dynamic>> joinRoom(Room r) {
    room = room;
    return request("joinRoom", r.toJson());
  }

  leaveRoom() {
    room = null;
    channel.sink.add(jsonEncode({"event": "leaveRoom"}));
  }

  syncPlayList(List<AliFile> files) {
    channel.sink.add(jsonEncode({
      'event': 'syncPlayList',
      'payload': [for (var f in files) f.toJson()]
    }));
  }

  syncEpisode(int i) {
    channel.sink.add(jsonEncode({
      'event': 'syncEpisode',
      'payload': {'index': i}
    }));
  }

  syncDuration(Duration duration) {
    channel.sink.add(jsonEncode({
      'event': 'syncDuration',
      'payload': {'duration': duration.inMilliseconds, 'time': DateTime.now().millisecondsSinceEpoch}
    }));
  }

  syncPlayingStatus(bool status) {
    channel.sink.add(jsonEncode({
      'event': 'syncPlayingStatus',
      'payload': {'playing': status}
    }));
  }

  syncSpeed(double speed) {
    channel.sink.add(jsonEncode({
      'event': 'syncSpeed',
      'payload': {'speed': speed}
    }));
  }
}
