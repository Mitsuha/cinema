import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:hourglass/basic.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';
import 'message_bag.dart';

typedef Message = Map<String, dynamic>;

class Distributor {
  late IOWebSocketChannel channel;

  final Map<String, StreamController<Message>> _listeners = {
    'reply': StreamController<Message>.broadcast()
  };

  final List<String> messageStack = [];

  bool isConnecting = false;

  static Distributor? _instance;

  static Distributor get instance => _instance ??= Distributor._internal();

  static void bootstrap() => Distributor.instance;

  Distributor._internal() {
    connect();
  }

  void connect() async {
    if (isConnecting) {
      return;
    }

    isConnecting = true;

    while (true) {
      try {
        var ws = await WebSocket.connect("ws://${Basic.remoteAddress}/ws").timeout(const Duration(seconds: 10));
        channel = IOWebSocketChannel(ws)..stream.listen(_message, onError: _error, onDone: _done);

        isConnecting = false;

        _connect();
        break;
      } catch (e) {
        continue;
      }
    }
  }

  void _message(dynamic message) {
    Map<String, dynamic> msg;

    log("received $message");

    msg = jsonDecode(message);

    if (msg['event'] == 'reply') {
      _listeners['reply']!.sink.add(msg);
      return;
    }

    if ((msg['event'] as String).startsWith('ask')) {
      _listeners[msg['event']]!.sink.add(msg);
      return;
    }

    if (_listeners.containsKey(msg['event'])) {
      _listeners[msg['event']]!.sink.add(msg['payload']);
    }
  }

  void _error(dynamic message) {
    _message('{"event": "disconnect","payload":{}}');
    connect();
  }

  void _done() {
    _message('{"event": "disconnect","payload":{}}');
    connect();
  }

  void _connect() {
    _message('{"event": "connect","payload":{}}');

    while (messageStack.isNotEmpty) {
      channel.sink.add(messageStack.removeAt(0));
    }
  }

  /// listen 监听事件
  StreamSubscription listen(String event, void Function(Message) handle) {
    if (!_listeners.containsKey(event)) {
      _listeners[event] = StreamController<Message>.broadcast();
    }

    return _listeners[event]!.stream.listen(handle);
  }

  /// 发送请求，会得到响应
  Future<Message> request(String event, payload) async {
    var id = const Uuid().v4().toString();

    channel.sink.add(jsonEncode({'event': event, 'id': id, 'payload': payload}));

    await for (var msg in _listeners['reply']!.stream) {
      if (msg['id'] == id) {
        return msg;
      }
    }

    return {};
  }

  emit(MessageBag message) {
    if (isConnecting) {
      messageStack.add(message.toString());
    } else {
      channel.sink.add(message.toString());
    }
  }
}
