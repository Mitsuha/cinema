import 'package:flutter/material.dart';
import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/model/message.dart';
import 'package:hourglass/model/room.dart';
import 'package:hourglass/model/user.dart';
import 'package:hourglass/runtime.dart';

class WatchState with ChangeNotifier {
  late Room room;

  late TabController tabController;

  bool get isOwner => room.master == Runtime.instance.user;

  List<AliFile> get playlist => room.playList;

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

enum KeyboardState {
  none,
  system,
  emoji,
}

class ChatState with ChangeNotifier {
  // bool get keyboardShow => keyboard.value != KeyboardState.none;

  List<Message> messages = [];

  void setState(VoidCallback callback) {
    callback();
    notifyListeners();
  }
}
