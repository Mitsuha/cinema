class User {
  String name;
  String avatar;
  String phone;
  int totalSize;
  int usedSize;

  User({
    required this.name,
    required this.avatar,
    this.phone = '',
    this.totalSize = 0,
    this.usedSize = 0,
  });

  factory User.fromJson(json) => User(
        name: json['nick_name'],
        avatar: json['avatar'] != ''
            ? json['avatar']
            : 'https://gw.alicdn.com/imgextra/i4/O1CN01Zqmj9x1yqaZster4k_!!6000000006630-2-tps-128-128.png',
        phone: json['phone'],
        totalSize: json['total_size'],
        usedSize: json['used_size'],
      );

  factory User.guest() => User(
        name: 'Guest',
        avatar: 'https://gw.alicdn.com/imgextra/i4/O1CN01Zqmj9x1yqaZster4k_!!6000000006630-2-tps-128-128.png',
        phone: '',
        totalSize: 1,
        usedSize: 0,
      );
}
