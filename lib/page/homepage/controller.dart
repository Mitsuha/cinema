import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hourglass/ali_driver/api.dart';
import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/model/room.dart';
import 'package:hourglass/model/user.dart';
import 'package:hourglass/page/homepage/state.dart';
import 'package:hourglass/page/watch/view.dart';
import 'package:hourglass/websocket/ws.dart';

class HomepageController {
  final HomepageState state = HomepageState();

  init() {
    getUserInfo();
    loadFile('root');

    state.addListener(() {
      if (state.userInitial && state.user.id != Ws.instance.user?.id) {
        Ws.instance.register(state.user);
      }
    });
  }

  getUserInfo() async {
    var profile = AliDriver.userProfile();

    var driverInfo = AliDriver.userDriverInfo();

    var result = await Future.wait([profile, driverInfo]);

    result[0].body.addAll(result[1].body['personal_space_info']);

    state.setUser(User.fromJson(result[0].body));
    User.auth = state.user;
  }

  loadFile(String folder) {
    AliDriver.fileList(parentFileID: folder).then((value) {
      state.setFile(value);
    });
  }

  hiddenFileSelector() {
    state.setFileSelectorShow(false);
  }

  showFileSelector() {
    state.setFileSelectorShow(true);
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

  goToPlay(BuildContext context, List<AliFile> videos) {
    if (Ws.connecting) {
      Fluttertoast.showToast(msg: '与服务器断开连接，无法创建房间');
      return;
    }

    Ws.instance.createRoom(videos).then((value) {
      var room = Room.fromJson(value['payload']);

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) => WatchPage(room: room)));
    });
  }

  onAppResumed(BuildContext context) {
    Clipboard.getData('text/plain').then((data) async {
      String text = (data?.text ?? '');

      if(text == ''){
        return;
      }

      try {
        RegExp regExp = RegExp(r'\#[0-9\s]*?\#');

        text = (regExp.allMatches(text).first.group(0)!).replaceAll('#', '').trim();

        var room = await getRoomInfo(int.parse(text));

        if(room == null){
          Fluttertoast.showToast(msg: '房间不存在');
          return;
        }

        if(room.master == User.auth){
          return;
        }

        Clipboard.setData(const ClipboardData(text: ''));

        showDialog(
          context: context,
          builder: (BuildContext dialogCtx) {
            return AlertDialog(
              title: const Text('看起来你有封邀请函'),
              content: Text('要加入 ${room.master.name} 的房间：${room.id} 吗？'),
              actions: [
                TextButton(
                  child: const Text('取消', style: TextStyle(color: Colors.grey)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('加入'),
                  onPressed: () {
                    Navigator.of(dialogCtx).pop();

                    joinRoom(context, room);
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        return;
      }
    });
  }

  Future<Room?> getRoomInfo(int roomID) async {
    var response = await Ws.instance.request('roomInfo', {'id': roomID});

    if (response['success'] == false) {
      return null;
    }
    return Room.fromJson(response['payload']);
  }

  joinRoom(BuildContext context, Room room) {
    Ws.instance.joinRoom(room).then((response) {
      if (response['payload']['success'] == false) {
        Fluttertoast.showToast(msg: response['payload']['message']);
      } else {
        room.addUser(User.auth);

        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return WatchPage(room: room);
        }));
      }
    });
  }
}
