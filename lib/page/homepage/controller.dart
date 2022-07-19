import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hourglass/ali_driver/api.dart';
import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/model/user.dart';
import 'package:hourglass/page/homepage/state.dart';
import 'package:hourglass/page/watch/view.dart';
import 'package:hourglass/websocket/ws.dart';

class HomepageController {
  final HomepageState state = HomepageState();

  init()  {
    getUserInfo();
    loadFile('root');

    state.addListener(() {
      if (state.userInitial && state.user.id != Ws.instance.user?.id) {
        Ws.instance.register(state.user);
      }
    });
  }

  getUserInfo()async {
    var profile = AliDriver.userProfile();

    var driverInfo = AliDriver.userDriverInfo();

    var result = await Future.wait([profile, driverInfo]);

    result[0].body.addAll(result[1].body['personal_space_info']);

    state.setUser(User.fromJson(result[0].body));
  }

  loadFile(String folder) {
    AliDriver.fileList(parentFileID: folder).then((value) {
      state.setFile(value);
    });
  }

  hiddenFileSelector(){
    state.setFileSelectorShow(false);
  }

  showFileSelector(){
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
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
      return WatchPage(playlist: videos);
    }));
  }
}
