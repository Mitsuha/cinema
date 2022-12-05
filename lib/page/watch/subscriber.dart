import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hourglass/ali_driver/api.dart';
import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/ali_driver/models/play_info.dart';
import 'package:hourglass/model/room.dart';
import 'package:hourglass/model/user.dart';
import 'package:hourglass/model/message.dart' as model;
import 'package:hourglass/page/watch/controller.dart';
import 'package:hourglass/helpers.dart';
import 'package:hourglass/runtime.dart';
import 'package:hourglass/websocket/distributor.dart';
import 'package:hourglass/websocket/message_bag.dart';

class RoomStreamListener {
  final WatchController _controller;
  final bool isOwner;

  Function? onDismissCall;

  List<StreamSubscription> subscriptions = [];

  RoomStreamListener(this._controller, this.isOwner) {
    var distributor = Distributor.instance;

    Map<String, Function(Message)> common = {
      "connect": onConnect,
      "joinRoom": onJoinRoom,
      "leaveRoom": onLeaveRoom,
      "dismissCurrent": onDismissCurrent,
      "chat": onChat,
    };

    Map<String, Function(Message)> onlyAudience = {
      "dismiss": onDismiss,
      "syncPlayList": onSyncPlayList,
      "syncEpisode": onSyncEpisode,
      "syncDuration": onSyncDuration,
      "syncPlayingStatus": onSyncPlayingStatus,
      "syncSpeed": syncSpeed,
    };

    common.forEach((event, action) {
      subscriptions.add(distributor.listen(event, action));
    });
    if (!isOwner) {
      onlyAudience.forEach((event, action) {
        subscriptions.add(distributor.listen(event, action));
      });
    } else {
      subscriptions.add(distributor.listen('askPlayInfo', replyPlayInfo));
    }
  }

  dispose() {
    for (var subscription in subscriptions) {
      subscription.cancel();
    }
  }

  replyPlayInfo(Message message) async {
    var playInfo = await AliDriver.videoPlayInfo(_controller.player.state.currentEpisode!.fileID);

    Distributor.instance
        .emit(RawMessage({'event': 'reply', 'id': message['id'], 'payload': playInfo.toJson()}));
  }

  onConnect(Message _) async {
    var response = await Distributor.instance.request('joinRoom', _controller.state.room.toJson());
    if (response['success'] == true) {
      var response =
          await Distributor.instance.request('roomInfo', {'id': _controller.state.room.id});

      if (response['success'] == true) {
        var room = Room.fromJson(response['payload']);
        _controller.state.room.users = room.users;
        _controller.chat.setState(() {
          _controller.chat.messages = room.message;
        });
      }
    }
  }

  onSyncPlayList(Message payload) {
    _controller.player.setPlayList([for (var p in payload['playlist']) AliFile.formJson(p)]);
  }

  onSyncEpisode(Message payload) {
    _controller.state.playlist[payload['index']].playInfo = PlayInfo.formJson(payload['playInfo']);

    _controller.state.room.duration = Duration.zero;
    _controller.state.room.speed = 1;

    _controller.selectEpisode(payload['index']);
  }

  onSyncDuration(Message duration) {
    /// 不能根据 本地时间-广播时间来计算延迟，会有时区问题

    var diff = duration['duration'] - _controller.player.position.inMilliseconds;
    var target = Duration(milliseconds: duration['duration']);

    // 30秒以外，直接跳转
    if (diff.abs() > 30000 || diff < -200) {
      _controller.player.seekTo(target);

      _controller.player.sendNotification(
        Text('房主快进到了：${target.humanRead()}'),
        const Duration(seconds: 1),
      );
    } else if (diff > 200) {
      if (_controller.player.isPlaying) {
        // 200 毫秒到 30 秒之间，快进过去
        _controller.player.speedTo(2, _controller.state.room.speed, target);

        _controller.player.sendNotification(
          const Text('2倍速同步中'),
          const Duration(seconds: 1),
        );
      } else {
        _controller.player.seekTo(target);
      }
    }
  }

  onSyncPlayingStatus(Message payload) {
    if (payload['playing']) {
      _controller.player.play();

      _controller.player.sendNotification(const Text('房间开始播放'), const Duration(seconds: 1));
    } else {
      _controller.player.pause();
      _controller.player.sendNotification(const Text('房间暂时停止了播放'), const Duration(seconds: 1));
    }
  }

  syncSpeed(Message payload) {
    _controller.player.playerController?.setPlaybackSpeed(payload['speed']);
    _controller.player
        .sendNotification(Text('房间调整到了${payload['speed']}倍速'), const Duration(seconds: 1));
  }

  onJoinRoom(Message u) {
    var user = User.fromJson(u);

    _controller.state.addUser(user);
    _controller.player.sendNotification(Text('${user.name}已加入房间'), const Duration(seconds: 1));
  }

  onLeaveRoom(Message u) {
    var user = User.fromJson(u);

    _controller.state.removeUser(user);
  }

  onDismiss(Message r) {
    var room = Room.fromJson(r);
    if (room == _controller.state.room) {
      onDismissCurrent(null);
    }
  }

  onDismissCurrent(_) {
    _controller.player.cancelFullScreen();

    if (onDismissCall != null) {
      onDismissCall!();
    }

    Fluttertoast.showToast(msg: '房间已被解散');
  }

  // 聊天
  onChat(Message m) {
    var message = model.Message.fromJson(m);
    if (message.user == Runtime.instance.user) {
      for (var element in _controller.chat.messages) {
        if (element.uuid == message.uuid) {
          element.state = model.MessageState.received;
          break;
        }
      }
    } else {
      _controller.chat.messages.add(message);
    }
    _controller.chat.setState(() {});
  }
}
