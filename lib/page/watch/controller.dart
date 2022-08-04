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
import 'package:hourglass/page/watch/subscriber.dart';
import 'package:hourglass/websocket/ws.dart';

class WatchController {
  late final PlayerController player = PlayerController(
      canControl: state.room.master == User.auth,
      listeners: PlayerListeners(
          onSwitchEpisode: onSwitchEpisode,
          onChangeSpeed: onChangeSpeed,
          onSeek: onSeekTo,
          onPause: onPause,
          onPlay: onPlay,
      ));

  final WatchState state = WatchState();
  RoomStreamSubscriber? subscriber;
  BuildContext? context;
  Timer? durationTimer;

  init(Room room) {
    setRoom(room);

    subscriber = RoomStreamSubscriber(this, Ws.instance.broadcast.stream, state.room.master == User.auth);
  }

  dispose() async {
    await player.dispose();
    subscriber?.dispose();
    durationTimer?.cancel();
    Ws.instance.leaveRoom();
  }

  setRoom(Room room) {
    state.setRoom(room);
    Ws.instance.room = room;

    if (room.playList != null) {
      setPlayList(room.playList!);
      selectEpisode(room.episode).then((_) {
        player.seekTo(room.duration);
        if (room.speed != 1) {
          player.playerController?.setPlaybackSpeed(room.speed);
        }
      });
    }
  }

  bool onSwitchEpisode(AliFile episode) {
    if (state.room.master == User.auth) {
      episode.loadPlayInfo().then((value) {
        Ws.instance.syncEpisode(player.playList.indexOf(episode));
        Ws.instance.syncPlayList(player.playList);
      });

      startSyncDuration();
    }
    return true;
  }

  bool onSeekTo(Duration duration) {
    if (state.room.master == User.auth) {
      Ws.instance.syncDuration(duration);
    }
    return true;
  }

  void onPause() {
    if (state.room.master == User.auth) {
      Ws.instance.syncPlayingStatus(false);
    }
  }

  void onPlay() {
    if (state.room.master == User.auth) {
      Ws.instance.syncPlayingStatus(true);
    }
  }

  bool onChangeSpeed(double speed){
    if (state.room.master == User.auth) {
      Ws.instance.syncSpeed(speed);
    }
    return true;
  }

  Future<bool> onWillPop(BuildContext context) async {
    if (player
        .getState()
        .orientation == Orientation.landscape) {
      await player.cancelFullScreen();
      return false;
    } else {
      bool back = false;
      await showDialog(context: context, builder: (BuildContext dialogCtx) {
        return AlertDialog(
          title: const Text("Wait..."),
          content: const Text("确定要退出房间吗？"),
          actions: [
            TextButton(
              child: const Text('取消', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(dialogCtx).pop();
                back = false;
              },
            ),
            TextButton(
              child: const Text('确定'),
              onPressed: () {
                Navigator.of(dialogCtx).pop();
                back = true;
              },
            ),
          ],
        );
      });

      return back;
    }
  }

  startSyncDuration() {
    durationTimer?.cancel();

    durationTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      Ws.instance.syncDuration(player.position);
    });
  }

  setPlayList(List<AliFile> playlist) {
    if (state.room.master == User.auth) {
      if (!playlist.first.playInfoLoaded) {
        playlist.first.loadPlayInfo().then((value) => Ws.instance.syncPlayList(playlist));
      }
    }

    player.setPlayList(playlist);
  }

  Future<void> selectEpisode(i) async {
    await player.selectEpisode(i);
    state.setState(() {});
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
