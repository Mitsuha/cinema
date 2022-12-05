import 'dart:convert';

import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/ali_driver/models/play_info.dart';
import 'package:hourglass/model/message.dart';
import 'package:hourglass/model/user.dart';

abstract class MessageBag {
  @override
  String toString();
}

class RawMessage implements MessageBag {
  final Map message;

  const RawMessage(this.message);

  @override
  String toString() {
    return jsonEncode(message);
  }
}

class SignupMessage implements MessageBag {
  final User user;

  const SignupMessage({required this.user});

  @override
  String toString() {
    return jsonEncode({'event': 'register', 'payload': user.toJson()});
  }
}

class LeaveRoomMessage implements MessageBag {
  @override
  String toString() {
    return '{"event": "leaveRoom"}';
  }
}

class ChangeSpeedMessage implements MessageBag {
  final double speed;

  const ChangeSpeedMessage({required this.speed});

  @override
  String toString() {
    return jsonEncode({
      'event': 'syncSpeed',
      'payload': {'speed': speed}
    });
  }
}

class SelectEpisodeMessage implements MessageBag {
  final int index;
  final List<PlayInfo> playInfo;

  const SelectEpisodeMessage({required this.index, required this.playInfo});

  @override
  String toString() {
    return jsonEncode({
      'event': 'syncEpisode',
      'payload': {'index': index, 'playInfo': [for (var p in playInfo) p.toJson()]}
    });
  }
}

class SeekToMessage implements MessageBag {
  final Duration duration;

  const SeekToMessage({required this.duration});

  @override
  String toString() {
    return jsonEncode({
      'event': 'syncDuration',
      'payload': {
        'duration': duration.inMilliseconds,
        'time': DateTime.now().millisecondsSinceEpoch
      }
    });
  }
}

class ChangePlayingStatusMessage implements MessageBag {
  final bool isPlaying;

  const ChangePlayingStatusMessage({required this.isPlaying});

  @override
  String toString() {
    return jsonEncode({
      'event': 'syncPlayingStatus',
      'payload': {'playing': isPlaying}
    });
  }
}

class SyncPlaylistMessage implements MessageBag {
  final List<AliFile> playlist;

  const SyncPlaylistMessage({required this.playlist});

  @override
  String toString() {
    return jsonEncode({
      'event': 'syncPlayList',
      'payload': {
        'playlist': [for (var f in playlist) f.toJson()]
      }
    });
  }
}

class ChatMessageBag implements MessageBag {
  final Message message;

  const ChatMessageBag({required this.message});

  @override
  String toString() {
    return jsonEncode({'event': 'chat', 'payload': message.toJson()});
  }
}
