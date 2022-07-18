import 'package:flutter/material.dart';
import 'package:hourglass/model/user.dart';

class WatchState with ChangeNotifier {
  var users = <User>[
    User(
        name: 'Pattie_Leffler',
        avatar: 'https://i1.hdslb.com/bfs/face/610a3328595d90e6f70d6a94e3066ea24ab04f5b.jpg@160w_160h_1c_1s.webp'),
    User(
        name: 'Elsie_Wunsch',
        avatar: 'https://i0.hdslb.com/bfs/face/c16356926a35089e4da68b7f16ebe14ac7dccac2.jpg@160w_160h_1c_1s.webp'),
    User(
        name: 'Linnea_White',
        avatar: 'https://i2.hdslb.com/bfs/face/1c53cbc7a5de2a9107d0931e6c2c93b2d1782415.jpg@160w_160h_1c_1s.webp'),
    User(
        name: 'Lilla_Abernathy',
        avatar: 'https://i1.hdslb.com/bfs/face/457e94788d3b6376a18866824976e53d38504c26.jpg@160w_160h_1c_1s.webp'),
    User(
        name: 'Elenor_Wisozk_II',
        avatar: 'https://i2.hdslb.com/bfs/face/a084fc923f911ed171d31c4e89a61fa6ceb98a9d.jpg@160w_160h_1c_1s.webp'),
    User(
        name: 'Jackie_Franecki',
        avatar: 'https://i0.hdslb.com/bfs/face/0702bc99f6a68c39a2d561b773e8c44c5d0c4272.jpg@160w_160h_1c_1s.webp'),
    User(
        name: 'Dr._Ezra_Osinski_MD',
        avatar: 'https://i2.hdslb.com/bfs/face/df0421e67f44141ae290f66c051b00c542c044d7.jpg@160w_160h_1c_1s.webp'),
    User(
        name: 'Jaydon_Kling',
        avatar: 'https://i1.hdslb.com/bfs/face/08f2854bfad6032818b8af0ee7a51ce931c0fb54.jpg@160w_160h_1c_1s.webp'),
    User(
        name: 'Tatum_Hauck',
        avatar: 'https://i0.hdslb.com/bfs/face/c57ae2a0df44c240a8254ff401a3def41267e47b.jpg@160w_160h_1c_1s.webp'),
    User(
        name: 'Mazie_Rempel_I',
        avatar: 'https://i2.hdslb.com/bfs/face/4620be30d40f5ee6b00db9abc9024bb95f10ec00.jpg@160w_160h_1c_1s.webp'),
  ];

  setState(VoidCallback callback) {
    callback();
    notifyListeners();
  }
}
