import 'package:flutter/material.dart';
import 'package:hourglass/model/room.dart';

class WatchState with ChangeNotifier {
  Room room = Room(id: 0, users: []);

  setRoom(Room r){
    room = r;
    notifyListeners();
  }

  setState(VoidCallback callback) {
    callback();
    notifyListeners();
  }
}
