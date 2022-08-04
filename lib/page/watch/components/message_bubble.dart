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
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color(0xffe4e6ee),
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
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
            decoration: const BoxDecoration(
              // color: toRight ? const Color(0xff95ec69): Colors.white,
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
              child: Text(message.content),
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
