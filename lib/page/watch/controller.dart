import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:hourglass/components/player/controller.dart';
import 'package:hourglass/model/message.dart' as model;
import 'package:hourglass/model/room.dart';
import 'package:hourglass/page/watch/listeners.dart';
import 'package:hourglass/page/watch/state.dart';
import 'package:hourglass/page/watch/subscriber.dart';
import 'package:hourglass/websocket/message_bag.dart';
import 'package:hourglass/websocket/distributor.dart';

class WatchController {
  final WatchState state = WatchState();
  final ChatState chat = ChatState();
  late final PlayerController player;
  late RoomStreamListener subscriber;
  late StreamSubscription connectListener;

  String get shareText {
    var fileName = player.currentEpisode?.name ?? '';

    fileName = fileName.substring(0, fileName.lastIndexOf('.'));

    return '嗨👋，我正在看 $fileName。快来 Hourglass 分享我的进度条，房间号：# ${state.room.id} #';
  }

  WatchController({required Room room}) {
    state.room = room;
    chat.messages = room.message;

    player = PlayerController(
      canControl: state.isOwner,
      listeners: state.isOwner
          ? OwnerListener(state: state, controller: this)
          : AudienceListener(state: state),
    );

    subscriber = RoomStreamListener(this, state.isOwner);

    player.setPlayList(room.playList);

    selectEpisode(room.episode).then((_) {
      syncRoomInfoToPlayer();
    });
  }

  dispose() {
    subscriber.dispose();
    Distributor.instance.emit(LeaveRoomMessage());
    player.dispose();
  }

  Future<void> selectEpisode(i) async {
    onChangeEpisode() => state.setState(() {});

    player.state.addListener(onChangeEpisode);

    await player.selectEpisode(i);

    player.state.removeListener(onChangeEpisode);
  }

  syncRoomInfoToPlayer() {
    if (!state.room.isPlaying) {
      player.pause();
    } else {
      player.play();
    }

    if (state.room.speed != 1) {
      player.playerController?.setPlaybackSpeed(state.room.speed);
    }

    if (!state.isOwner) {
      player.seekTo(state.room.duration);
    }
  }

  sendMessage(TextEditingController textEdit, ScrollController chatView) {
    if (textEdit.value.text.trim() == '') {
      return;
    }
    var message = model.Message.me(content: textEdit.value.text);

    Distributor.instance.emit(ChatMessageBag(message: message));

    chat.setState(() => chat.messages.add(message));

    textEdit.text = '';
  }

  leaveRoom(){
    Distributor.instance.emit(LeaveRoomMessage());
  }
}
