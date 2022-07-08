import 'package:flutter/foundation.dart';
import 'package:hourglass/ali_driver/models/file.dart';

class PlayerState with ChangeNotifier {
  var playlist = <AliFile>[];
  AliFile? currentPlayAliFile;
}