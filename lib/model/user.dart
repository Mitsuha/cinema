import 'package:flutter/material.dart';
import 'package:hourglass/runtime.dart';

class User with ChangeNotifier {
  int id;
  String aliID;
  String name;
  String avatar;
  String phone;
  int totalSize;
  int usedSize;

  User({
    required this.id,
    required this.aliID,
    required this.name,
    required this.avatar,
    this.phone = '',
    this.totalSize = 0,
    this.usedSize = 0,
  });

  merge(User user) {
    id = user.id;
    name = user.name;
    avatar = user.avatar;
    phone = user.phone;
    totalSize = user.totalSize;
    usedSize = user.usedSize;
  }

  toJson() => {
        "id": id,
        "ali_id": aliID,
        "phone": phone,
        "name": name,
        "avatar": avatar,
      };

  static User get auth => Runtime.instance.user!;

  factory User.fromJson(json) => User(
        id: json['id'] ?? 0,
        aliID: json['user_id'] ?? json['ali_id'],
        name: json['nick_name'] ?? json['name'],
        avatar: json['avatar'] != ''
            ? json['avatar']
            : 'https://gw.alicdn.com/imgextra/i4/O1CN01Zqmj9x1yqaZster4k_!!6000000006630-2-tps-128-128.png',
        phone: json['phone'] ?? '',
        totalSize: json['total_size'] ?? 0,
        usedSize: json['used_size'] ?? 0,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is User && runtimeType == other.runtimeType && aliID == other.aliID;

  @override
  int get hashCode => id.hashCode;
}
