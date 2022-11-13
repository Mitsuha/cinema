import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/model/room.dart';
import 'package:hourglass/model/user.dart';
import 'package:hourglass/page/watch/controller.dart';
import 'package:hourglass/helpers.dart';

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
    Map<String, Function> map = {
      "joinRoom": onJoinRoom,
      "leaveRoom": onLeaveRoom,
      "dismiss": onDismiss,
      "dismissCurrent": onDismissCurrent,
      "syncPlayList": onSyncPlayList,
      "syncEpisode": onSyncEpisode,
      "syncDuration": onSyncDuration,
      "syncPlayingStatus": onSyncPlayingStatus,
      "syncSpeed": syncSpeed,
    };

    if (map[event['event']] != null) {
      map[event['event']]!(event['payload']);
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
      if (diff.abs() > 100) {
        var target = Duration(milliseconds: duration['duration'] + 3);
        // var speed = _controller.state.room.speed * 2;

        // if ((target.inMinutes - _controller.player.position.inMinutes).abs() >= 2) {
        //   _controller.player.seekTo(target);
        // }
        _controller.player.seekTo(target);
        _controller.player
            .sendNotification(Text('房主快进到了：${target.toVideoString()}'), const Duration(seconds: 1));
        // _controller.player.speedTo(speed, _controller.state.room.speed, target);
      }
    }
  }

  onSyncPlayingStatus(Map<String, dynamic> payload) {
    if (!imNotBlack) {
      if (payload['playing']) {
        _controller.player.play();

        _controller.player.sendNotification(const Text('房间开始播放'), const Duration(seconds: 1));
      } else {
        _controller.player.pause();
        _controller.player.sendNotification(const Text('房间暂时停止了播放'), const Duration(seconds: 1));
      }
    }
  }

  syncSpeed(Map<String, dynamic> payload) {
    if (!imNotBlack) {
      _controller.player.playerController?.setPlaybackSpeed(payload['speed']);
      _controller.player
          .sendNotification(Text('房间调整到了${payload['speed']}倍速'), const Duration(seconds: 1));
    }
  }

  onJoinRoom(Map<String, dynamic> u) {
    var user = User.fromJson(u);

    _controller.state.addUser(user);
    _controller.player.sendNotification(Text('${user.name}已加入房间'), const Duration(seconds: 1));
  }

  onLeaveRoom(Map<String, dynamic> u) {
    var user = User.fromJson(u);

    _controller.state.removeUser(user);
  }

  onDismiss(Map<String, dynamic> r) {
    var room = Room.fromJson(r);
    if (room == _controller.state.room) {
      onDismissCurrent(null);
    }
  }

  onDismissCurrent(_) {
    _controller.player.cancelFullScreen();

    Navigator.of(_controller.context!).pop();

    Fluttertoast.showToast(msg: '房间已被解散');
  }
}
