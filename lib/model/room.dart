import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/model/user.dart';

class Room {
  int id;
  User master;
  List<User> users;
  AliFile? currentPlay;
  List<AliFile>? playList;

  Room({required this.id, required this.master, required this.users, this.currentPlay, this.playList});

  factory Room.fromJson(json) => Room(
        id: json['id'],
        master: User.fromJson(json['master']),
        users: [for (var u in json['users']) User.fromJson(u)],
        currentPlay: json['currentPlay'] == null ? null : AliFile.formJson(json['id']),
        playList: [for (var p in (json['playlist'] ?? [])) AliFile.formJson(p)],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'master': master,
      };
}
