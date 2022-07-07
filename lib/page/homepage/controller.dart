import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hourglass/ali_driver/api.dart';
import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/page/video_play/view.dart';

class HomepageController {
  static HomepageController? _instance;

  final fileListChangeNotifier = StreamController<bool>.broadcast();
  var folderPaths = <String>['root'];
  List<AliFile> files = [];

  /// file selector pop animation
  var selectorShow = ValueNotifier(false);
  var selectorShowed = ValueNotifier(false);

  /// BuildContext for routed to video player
  BuildContext ?context;

  static init() {
    HomepageController._internal();
  }

  static HomepageController getInstance() {
    _instance ??= HomepageController._internal();

    return _instance!;
  }

  HomepageController._internal() {
    if (_instance != null) {
      return;
    }
  }

  loadFile(String folder) {
    AliDriver.fileList(parentFileID: folder).then((value) {
      files = value;
      fileListChangeNotifier.add(true);
    });
  }

  openFile(AliFile file) {
    if (file.isFolder) {
      folderPaths.add(file.parentFileID);

      loadFile(file.fileID);
    } else if (file.isVideo) {
      goToPlay([file]);
    } else {
      Fluttertoast.showToast(msg: '不支持预览视频以外的文件');
    }
  }

  backToParentFolder() {
    if (folderPaths.length == 1) {
      return loadFile('root');
    }
    loadFile(folderPaths.removeLast());
  }

  playCurrentFolder() {
    var videos = files.where((element) => element.isVideo).toList();

    if (videos.isEmpty) {
      Fluttertoast.showToast(msg: '当前文件夹下没有可播放的视频');
      return;
    }
    goToPlay(videos);
  }

  goToPlay(List<AliFile> videos) {
    Navigator.of(context!).pop();
    Navigator.of(context!).push(MaterialPageRoute(builder: (BuildContext context){
      return VideoPlayPage(playlist: videos);
    }));
  }
}
