import 'package:flutter/material.dart';
import 'package:hourglass/basic.dart';
import 'package:hourglass/model/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool toRight;

  const MessageBubble(this.message, {this.toRight = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget avatar = SizedBox(
      width: 36,
      child: ClipOval(
        child: Image.network(message.user.avatar, headers: Basic.originHeader),
      ),
    );
    Widget text = Expanded(
      child: Column(
        crossAxisAlignment: toRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message.user.name,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 3),
          DecoratedBox(
            decoration: BoxDecoration(
              color: toRight ? null : const Color(0xff3e3a53),
              gradient: !toRight
                  ? null
                  : const LinearGradient(colors: [Color(0xff8275dd), Color(0xff9e6ed7)]),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
              child: Text(message.content, style: const TextStyle(fontSize: 15, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
    Widget sized = const SizedBox(width: 36);
    Widget spacing = const SizedBox(width: 5);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: toRight ? [sized, text, spacing, avatar] : [avatar, spacing, text, sized],
    );
  }
}
