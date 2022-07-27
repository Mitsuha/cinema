extension DurationToString on Duration{
  String toVideoString(){
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
