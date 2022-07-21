import 'package:flutter/material.dart';
import 'package:hourglass/model/room.dart';
import 'package:hourglass/model/user.dart';

class WatchState with ChangeNotifier {
  Room room = Room(id: 0, master: User.guest(), users: []);

  setRoom(Room r){
    room = r;
    notifyListeners();
  }

  setState(VoidCallback callback) {
    callback();
    notifyListeners();
  }
}
