import 'dart:async';

import 'package:hourglass/ali_driver/api.dart';
import 'package:hourglass/ali_driver/models/file.dart';

class HomepageController {
  static HomepageController? _instance;

  final fileListChangeNotifier = StreamController<bool>.broadcast();
  List<AliFile> files = [];

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

  loadFile() {
    AliDriver.fileList().then((value) {
      files = value;
      fileListChangeNotifier.add(true);
    });
  }
}
