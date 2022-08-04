import 'package:flutter/material.dart';
import 'package:hourglass/model/message.dart';
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

  List<Message> messages = [
    Message(content: '呜呜呜，我已经搬了一上午砖了', user: User.auth, type: 1),
    Message(content: '今天工地的砖格外烫手', user: User.auth, type: 1),
    Message(content: '今天还好吧周四那个才烫', user: User.auth, type: 1),
    Message(content: '牛马东西跟我捂捂喳喳', user: User.auth, type: 1),
    Message(content: '浅浅觉觉', user: User.auth, type: 1),
    Message(content: '今天的午饭', user: User.auth, type: 1),
    Message(content: '你这吃不饱吧你', user: User.auth, type: 1),
    Message(content: '俩汉堡', user: User.auth, type: 1),
    Message(content: '这个表情包我用了三年', user: User.auth, type: 1),
    Message(content: '看了三年', user: User.auth, type: 1),
    Message(content: '吃不饱但也不能再拿一个了', user: User.auth, type: 1),
    Message(content: '@山东亖受亖苗 为什么不可以为什么不可以为什么不可以为什么不可以', user: User.auth, type: 1),
    Message(content: 'content', user: User.auth, type: 1),
    Message(content: '为什么不可以', user: User.auth, type: 1),
    Message(content: '好困', user: User.auth, type: 1),
    Message(content: '抢一个！', user: User.auth, type: 1),
    Message(content: '抢十个', user: User.auth, type: 1),
    Message(content: '我是大恶棍', user: User.auth, type: 1),
  ];

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
