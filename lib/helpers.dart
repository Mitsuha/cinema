extension ToString on Duration{
  String toVideoString(){
    var str = toString();

    str = str.split('.').first;

    if(inHours == 0){
      return str.substring(2);
    }
    return str;
  }
}