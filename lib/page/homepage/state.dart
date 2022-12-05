import 'package:flutter/material.dart';
import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/model/user.dart';

class HomepageState with ChangeNotifier {
  var folderPaths = <String>['root'];
  List<AliFile> files = [];
  late User user;// = User.guest();
  bool userInitial = false;

  /// file selector show
  bool fileSelectorShow = false;

  setUser(User u){
    user = u;
    userInitial = true;
    notifyListeners();
  }

  setFileSelectorShow(bool show){
    fileSelectorShow = show;
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

class FileSelectorState with ChangeNotifier{
  bool isShow = false;

  show() {
    isShow = true;
    notifyListeners();
  }

  hidden(){
    isShow = false;
    notifyListeners();
  }
}