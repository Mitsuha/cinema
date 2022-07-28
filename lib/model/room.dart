import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/model/user.dart';

class Room {
  int id;
  User master;
  List<User> users;
  AliFile? currentPlay;
  List<AliFile>? playList;
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
    this.currentPlay,
    this.playList,
  });

  factory Room.fromJson(json) => Room(
        id: json['id'],
        episode: json['episode'],
        speed: (json['speed'] as int).toDouble(),
        isPlaying: json['is_playing'] ?? true,
        master: User.fromJson(json['master']),
        duration: Duration(milliseconds: json['duration']),
        users: [for (var u in json['users']) User.fromJson(u)],
        currentPlay: json['currentPlay'] == null ? null : AliFile.formJson(json['id']),
        playList: [for (var p in (json['playlist'] ?? [])) AliFile.formJson(p)],
      );

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
