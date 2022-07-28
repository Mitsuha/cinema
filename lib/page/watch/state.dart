import 'package:flutter/material.dart';
import 'package:hourglass/model/room.dart';
import 'package:hourglass/model/user.dart';

class WatchState with ChangeNotifier {
  Room room = Room(
    id: 0,
    master: User.guest(),
    users: [],
    episode: 0,
    duration: Duration.zero,
    speed: 1,
    isPlaying: false,
  );
  bool dismiss = false;

  setRoom(Room r) {
    room = r;
    notifyListeners();
  }

  setState(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  addUser(User user) {
    room.addUser(user);
    notifyListeners();
  }

  removeUser(User user) {
    room.users.remove(user);
    notifyListeners();
  }
}
