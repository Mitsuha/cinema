import 'package:hourglass/model/user.dart';

class Message{
  final String content;
  final User user;
  final int type;

  Message({required this.content, required this.user, required this.type});
}