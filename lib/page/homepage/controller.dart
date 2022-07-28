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
    state.fileSelectorVisible = true;
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
    Ws.instance.createRoom(videos).then((value) {
      var room = Room.fromJson(value['payload']);

      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => WatchPage(room: room)));
    });
  }

  onAppResumed(BuildContext context) {
    Clipboard.getData('text/plain').then((data) async {
      // String text = (data?.text ?? '');
      String text = '嗨👋，我正在看 Stranger.Things.S04E01。快来 Hourglass 分享我的进度条，房间号：# 21066 #';

      try {
        RegExp regExp = RegExp(r'\#[0-9\s]*?\#');

        text = (regExp.allMatches(text).first.group(0)!).replaceAll('#', '').trim();

        var response = await Ws.instance.request('roomInfo', {'id': int.parse(text)});

        if (response["payload"]['success'] == false) {
          Fluttertoast.showToast(msg: response['payload']['message']);
          return;
        }
        var room = Room.fromJson(response['payload']);

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
