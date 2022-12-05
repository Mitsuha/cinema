import 'package:hourglass/model/user.dart';
import 'package:hourglass/runtime.dart';
import 'package:uuid/uuid.dart';

enum MessageState {
  sending,
  received,
}

class Message {
  final int roomID;
  final int userID;
  final String content;
  final User user;
  final String uuid;
  MessageState state;

  Message({
    required this.roomID,
    required this.userID,
    required this.content,
    required this.user,
    required this.uuid,
    this.state = MessageState.received,
  });

  factory Message.me({required String content}) {
    return Message(
      roomID: 0,
      userID: Runtime.instance.user!.id,
      content: content,
      user: Runtime.instance.user!,
      uuid: const Uuid().v1(),
      state: MessageState.sending,
    );
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'],
      user: User.fromJson(json['user']),
      uuid: json['uuid'],
      roomID: json['room_id'],
      userID: json['user']['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'user': user.toJson(),
      'uuid': uuid,
      'room_id': roomID,
      'user_id': userID
    };
  }
}
