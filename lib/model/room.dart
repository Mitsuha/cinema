import 'dart:developer';

import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/model/message.dart';
import 'package:hourglass/model/user.dart';

class Room {
  int id;
  User master;
  List<User> users;
  List<AliFile> playList;
  List<Message> message;
  int episode;
  Duration duration;
  double speed;
  bool isPlaying;

  Room({
    required this.id,
    required this.master,
    required this.users,
    required this.episode,
    required this.duration,
    required this.speed,
    required this.isPlaying,
    required this.playList,
    required this.message,
  });

  AliFile get currentPlay => playList[episode];

  factory Room.fromJson(Map<String, dynamic> json) {
    log(json.toString());

    List<AliFile> playList = [for (var p in (json['playlist'] ?? [])) AliFile.formJson(p)];


    return Room(
      id: json['id'],
      episode: json['episode'],
      speed: (json['speed'] as int).toDouble(),
      isPlaying: json['is_playing'] ?? true,
      master: User.fromJson(json['master']),
      duration: Duration(milliseconds: json['duration']),
      users: [for (var u in json['users']) User.fromJson(u)],
      message: json['message'] == null ? [] : [for (var m in json['message']) Message.fromJson(m)],
      playList: playList,
    );
  }

  // on join room
  Map<String, dynamic> toJson() => {
        'id': id,
        'master': master,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Room && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  addUser(User user) {
    for (var u in users) {
      if (u == user) {
        return;
      }
    }
    users.add(user);
  }
}
