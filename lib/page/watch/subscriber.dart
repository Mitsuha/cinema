import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/model/room.dart';
import 'package:hourglass/model/user.dart';
import 'package:hourglass/page/watch/controller.dart';

class RoomStreamSubscriber {
  final WatchController _controller;
  final Stream _stream;
  final bool imNotBlack;

  /// not black == not slave == master
  late StreamSubscription _subscription;

  RoomStreamSubscriber(this._controller, this._stream, this.imNotBlack) {
    _subscription = _stream.listen(distribution);
  }

  dispose() {
    _subscription.cancel();
  }

  distribution(event) {
    switch (event['event']) {
      case "joinRoom":
        onJoinRoom(event['payload']);
        break;
      case "leaveRoom":
        onLeaveRoom(event['payload']);
        break;
      case "dismiss":
        onDismiss(event['payload']);
        break;
      case "syncPlayList":
        onSyncPlayList(event['payload']);
        break;
      case "syncEpisode":
        onSyncEpisode(event['payload']);
        break;
      case "syncDuration":
        onSyncDuration(event['payload']);
    }
  }

  onSyncPlayList(List payload) {
    if (!imNotBlack) {
      _controller.setPlayList([for (var p in payload) AliFile.formJson(p)]);
    }
  }

  onSyncEpisode(Map<String, dynamic> payload) {
    if (!imNotBlack) {
      _controller.selectEpisode(payload['index']);
    }
  }

  onSyncDuration(Map<String, dynamic> duration) {
    if (!imNotBlack) {
      var diff = (duration['duration'] - _controller.player.position.inMilliseconds) as int;
      if (diff.abs() > 1000) {
        var delay = DateTime.now().millisecondsSinceEpoch -
            duration['time'] +
            (diff > 5 * Duration.millisecondsPerMinute ? 20 : 5);

        _controller.player.speedTo(Duration(milliseconds: duration['duration'] + delay));
      }
    }
  }

  onJoinRoom(Map<String, dynamic> u){
    var user = User.fromJson(u);

    _controller.state.addUser(user);
  }

  onLeaveRoom(Map<String, dynamic> u){
    var user = User.fromJson(u);

    _controller.state.removeUser(user);
  }

  onDismiss(Map<String, dynamic> r){
    var room = Room.fromJson(r);
    if(room == _controller.state.room){
      _controller.player.cancelFullScreen();

      Navigator.of(_controller.context!).pop();

      Fluttertoast.showToast(msg: '房间已被解散');
    }
  }
}
