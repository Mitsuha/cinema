import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String id;
  String name;
  String avatar;
  String phone;
  int totalSize;
  int usedSize;
  bool guest;

  static User? _auth;

  User({
    required this.id,
    required this.name,
    required this.avatar,
    this.phone = '',
    this.totalSize = 0,
    this.usedSize = 0,
    this.guest = false,
  });

  merge(User user) {
    id = user.id;
    name = user.name;
    avatar = user.avatar;
    phone = user.phone;
    totalSize = user.totalSize;
    usedSize = user.usedSize;
    guest = user.guest;
  }

  toJson() => {
        "id": id,
        "name": name,
        "avatar": avatar,
      };

  static User get auth => _auth!;
  static set auth (User u) => _auth = u;

  factory User.fromJson(json) => User(
        id: json['user_id'] ?? json['id'],
        name: json['nick_name'] ?? json['name'],
        avatar: json['avatar'] != ''
            ? json['avatar']
            : 'https://gw.alicdn.com/imgextra/i4/O1CN01Zqmj9x1yqaZster4k_!!6000000006630-2-tps-128-128.png',
        phone: json['phone'] ?? '',
        totalSize: json['total_size'] ?? 0,
        usedSize: json['used_size'] ?? 0,
      );

  factory User.guest() => User(
        id: '',
        name: 'Guest',
        avatar: 'https://gw.alicdn.com/imgextra/i4/O1CN01Zqmj9x1yqaZster4k_!!6000000006630-2-tps-128-128.png',
        phone: '',
        totalSize: 1,
        usedSize: 0,
        guest: true,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
