import 'dart:async';
import 'dart:developer';

import 'package:hourglass/ali_driver/api.dart';
import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/components/player/listeners.dart';
import 'package:hourglass/page/watch/controller.dart';
import 'package:hourglass/page/watch/state.dart';
import 'package:hourglass/websocket/message_bag.dart';
import 'package:hourglass/websocket/distributor.dart';

class OwnerListener implements PlayerEvent {
  final WatchState state;
  final WatchController controller;
  Timer? durationTimer;

  int _updatePlayList = 0;

  OwnerListener({required this.controller, required this.state});

  /// 播放器被初始化
  @override
  inited() {
    durationTimer?.cancel();

    durationTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      Distributor.instance.emit(SeekToMessage(duration: controller.player.position));
    });
  }

  /// 播放器被销毁
  @override
  dispose() => durationTimer?.cancel();

  /// 当房主调整播放倍速时
  @override
  bool onChangeSpeed(double speed) {
    Distributor.instance.emit(ChangeSpeedMessage(speed: speed));
    return true;
  }

  /// 当房主选择暂停/播放时
  @override
  bool onChangeStatus(bool playing) {
    Distributor.instance.emit(ChangePlayingStatusMessage(isPlaying: playing));
    return true;
  }

  /// 调整进度条，定时同步
  @override
  bool onSeek(Duration duration) {
    Distributor.instance.emit(SeekToMessage(duration: duration));
    return true;
  }

  /// 切换选集
  @override
  Future<bool> onSwitchEpisode(int index, AliFile episode) async {
    var playInfo = await Future.wait([
      for (var i = 0; i < controller.state.room.users.length; i++)
        AliDriver.videoPlayInfo(episode.fileID)
    ]);
    log(playInfo.toString());

    episode.playInfo = playInfo.removeLast();

    Future.microtask(
      () => Distributor.instance.emit(SelectEpisodeMessage(index: index, playInfo: playInfo)),
    );
    return true;
  }

  @override
  bool onUpdatePlaylist(List<AliFile> playlist) {
    state.setState(() {});
    if (_updatePlayList++ != 0) {
      Distributor.instance.emit(SyncPlaylistMessage(playlist: playlist));
    }
    return true;
  }
}

class AudienceListener extends PlayerEvent {
  final WatchState state;

  AudienceListener({required this.state});

  @override
  bool onUpdatePlaylist(List<AliFile> playlist) {
    state.setState(() {});
    return true;
  }
}
