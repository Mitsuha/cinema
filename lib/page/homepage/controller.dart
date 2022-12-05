import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hourglass/ali_driver/api.dart';
import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/ali_driver/models/play_info.dart';
import 'package:hourglass/model/room.dart';
import 'package:hourglass/model/user.dart';
import 'package:hourglass/page/homepage/state.dart';
import 'package:hourglass/page/watch/view.dart';
import 'package:hourglass/runtime.dart';
import 'package:hourglass/websocket/distributor.dart';

class HomepageController {
  final HomepageState state = HomepageState();
  final FileSelectorState fileSelector = FileSelectorState();

  init() {
    getUserInfo().then((user) {
      state.setUser(user);

      Distributor.instance.request('register', user).then((Map<String, dynamic> message) {
        if (message['success'] == true) {
          user.id = User.fromJson(message['payload']).id;

          Runtime.instance.user = user;
        } else {
          Fluttertoast.showToast(msg: '登录失败，请清除软件数据重试');
        }
      });

      loadFile('root');
    });
  }

  Future<User> getUserInfo() async {
    var profile = AliDriver.userProfile();

    var driverInfo = AliDriver.userDriverInfo();

    var result = await Future.wait([profile, driverInfo]);

    result[0].body.addAll(result[1].body['personal_space_info']);

    return User.fromJson(result[0].body);
  }

  loadFile(String folder) {
    AliDriver.fileList(parentFileID: folder).then((value) {
      state.setFile(value);
    });
  }

  openFile(BuildContext context, AliFile file) {
    if (file.isFolder) {
      state.folderPaths.add(file.parentFileID);

      loadFile(file.fileID);
    } else if (file.isVideo) {
      goToPlay(context, [file]);
    } else {
      Fluttertoast.showToast(msg: '不支持预览视频以外的文件');
    }
  }

  backToParentFolder() {
    if (state.folderPaths.length == 1) {
      return loadFile('root');
    }
    loadFile(state.folderPaths.removeLast());
  }

  playCurrentFolder(BuildContext context) {
    var videos = state.files.where((element) => element.isVideo).toList();

    if (videos.isEmpty) {
      Fluttertoast.showToast(msg: '当前文件夹下没有可播放的视频');
      return;
    }
    goToPlay(context, videos);
  }

  goToPlay(BuildContext context, List<AliFile> videos) async {
    if (Distributor.instance.isConnecting) {
      Fluttertoast.showToast(msg: '与服务器断开连接，无法创建房间');
      return;
    }

    final navigator = Navigator.of(context);

    var response = await Distributor.instance.request(
      'createRoom',
      [for (var p in videos) p.toJson()],
    );

    navigator.push(MaterialPageRoute(
      builder: (BuildContext context) => WatchPage(room: Room.fromJson(response['payload'])),
    ));
  }

  Future<Room?> getRoomInfo(int roomID) async {
    var response = await Distributor.instance.request('roomInfo', {'id': roomID});

    if (response['success'] == false) {
      return null;
    }

    return Room.fromJson(response['payload']);
  }

  joinRoom(NavigatorState navigator, Room room) async {
    var response = await Distributor.instance.request('joinRoom', room.toJson());

    if (response['payload']['success'] == false) {
      Fluttertoast.showToast(msg: response['payload']['message']);
    } else {
      room.currentPlay.playInfo = PlayInfo.formJson(response['payload']);
      room.addUser(User.auth);

      navigator.push(MaterialPageRoute(builder: (BuildContext context) => WatchPage(room: room)));
    }
  }

  Future<Room?> getRoomInfoFromClipboard() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    String text = (data?.text ?? '');

    if (text == '') {
      return null;
    }

    try {
      RegExp regExp = RegExp(r'\#[0-9\s]*?\#');

      text = (regExp.allMatches(text).first.group(0)!).replaceAll('#', '').trim();

      return await getRoomInfo(int.parse(text));
    } catch (_) {
      return null;
    }
  }
}
