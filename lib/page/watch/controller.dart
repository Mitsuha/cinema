import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/components/player/controller.dart';
import 'package:hourglass/components/player/listeners.dart';
import 'package:hourglass/model/room.dart';
import 'package:hourglass/model/user.dart';
import 'package:hourglass/page/watch/state.dart';
import 'package:hourglass/websocket/ws.dart';

class WatchController {
  late final PlayerController player = PlayerController(listeners: PlayerListeners(
    onSwitchEpisode: onSwitchEpisode,
  ));

  final WatchState state = WatchState();
  StreamSubscription? streamSubscription;

  init(Room room) {
    setRoom(room);

    streamSubscription = Ws.instance.broadcast.stream.listen((event) {
      if (event['event'] == 'syncPlayList') {
        onSyncPlayList(event['payload']);
      }
    });
  }

  dispose() async {
    await player.dispose();
    streamSubscription?.cancel();
  }

  setRoom(Room room) {
    state.setRoom(room);
    Ws.instance.room = room;

    if (room.playList != null) {
      setPlayList(room.playList!);
    }
  }

  onSyncPlayList(List payload) {
    if (state.room.master == User.auth) {
      return;
    }

    setPlayList([for (var p in payload) AliFile.formJson(p)]);
  }

  bool onSwitchEpisode(AliFile episode){
    if(state.room.master == User.auth){
      episode.loadPlayInfo().then((value) => Ws.instance.syncPlayList(state.room.playList!));
    }
    return true;
  }

  setPlayList(List<AliFile> playlist) {
    if (state.room.master == User.auth) {
      if (!playlist.first.playInfoLoaded) {
        playlist.first.loadPlayInfo().then((value) => Ws.instance.syncPlayList(playlist));
      }
    }

    player.setPlayList(playlist);
  }

  selectEpisode(i) {
    state.setState(() => player.selectEpisode(i));
  }

  invitationPopup(BuildContext context) {
    if (state.room.id == 0) {
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          var fileName = player.currentEpisode?.name ?? '';

          fileName = fileName.substring(0, fileName.lastIndexOf('.'));

          var content = '嗨👋，我正在看 $fileName。快来 Hourglass 分享我的进度条，房间号：# ${state.room.id} #';

          return AlertDialog(
            title: const Text('邀请朋友'),
            content: Text(content),
            actions: [
              TextButton(
                child: const Text('取消', style: TextStyle(color: Colors.grey)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                  child: const Text('复制'),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: content)).then((_) {
                      Fluttertoast.showToast(msg: '已复制到剪切板');
                    });
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }
}
