import 'dart:convert';

import 'package:hourglass/model/user.dart';

class Room{
  int id;
  List<User> users;

  Room({required this.id,required this.users});

  factory Room.fromJson(json) => Room(id: json['id'], users: [
    for(var u in json['users'])
      User.fromJson(u)
  ]);
}