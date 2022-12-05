import 'package:flutter/material.dart';

extension DurationToString on Duration{
  String humanRead(){
    var str = toString();

    str = str.split('.').first;

    if(inHours == 0){
      return str.substring(2);
    }
    return str;
  }
}

extension DateTimeToString on DateTime{
  String diffForHuman(){
    final Duration difference = DateTime.now().difference(this);
    final int sec = difference.inSeconds;

    if (sec >= 60 * 60 * 24) {
      return '${difference.inDays.toString()}天前';
    } else if (sec >= 60 * 60) {
      return '${difference.inHours.toString()}小时前';
    } else if (sec >= 60) {
      return '${difference.inMinutes.toString()}分前';
    } else {
      return '$sec秒前';
    }
  }

}

extension IntToString on int{
  String toByteString(){
    var a = toDouble();
    for (var element in ['KB', 'MB', 'GB', 'TB', 'PB']) {
      if (a / 1024 > 1024) {
        a = a / 1024;
      }else{
        return (a / 1024).toStringAsFixed(2) + element;
      }
    }
    return toString();
  }
}

extension InsetText on TextEditingController {
  void inset(String text) {
    final selection = TextSelection.collapsed(
      offset: text.length +
          (!value.selection.isValid ? value.text.length : value.selection.extentOffset),
    );

    if ((value.selection.isCollapsed && value.selection.baseOffset == 0) ||
        !value.selection.isValid) {
      this.text = text + value.text;
    } else if (value.selection.isCollapsed && value.selection.baseOffset == value.text.length) {
      this.text = value.text + text;
    } else {
      var left = value.text.substring(0, value.selection.baseOffset);
      var right = value.text.substring(value.selection.extentOffset);
      this.text = left + text + right;
    }

    this.selection = selection;
  }
}
