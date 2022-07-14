import 'package:flutter/material.dart';
import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/model/user.dart';

class HomepageState with ChangeNotifier {
  var folderPaths = <String>['root'];
  List<AliFile> files = [];
  User user = User.guest();

  /// file selector show
  bool fileSelectorShow = false;
  bool fileSelectorVisible = false;

  setUser(User u){
    user = u;
    notifyListeners();
  }

  setFileSelectorShow(bool show){
    fileSelectorShow = show;
    notifyListeners();
  }

  setFileSelectorVisible(bool visible){
    fileSelectorVisible = visible;
    notifyListeners();
  }

  setFile(List<AliFile> f){
    files = f;
    notifyListeners();
  }

  update(){
    notifyListeners();
  }
}