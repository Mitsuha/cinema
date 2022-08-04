import 'package:flutter/material.dart';
import 'package:hourglass/page/watch/components/audience.dart';
import 'package:hourglass/page/watch/components/message_bubble.dart';
import 'package:provider/provider.dart';
import '../state.dart';

class WatchChat extends StatelessWidget {
  const WatchChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = context.watch<WatchState>();

    return Column(
      children: [
        WatchAudience(state.room.users),
        Expanded(
          child: ColoredBox(
            color: const Color(0xfff5f5f5),
            child: ListView.builder(
                itemCount: state.messages.length,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: MessageBubble(state.messages[i], toRight: i % 2 == 1),
                  );
                }),
          ),
        ),
        SizedBox(
          height: 50,
          child: Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.keyboard_voice)),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    // autofocus: true,
                    maxLines: 10,
                    decoration: InputDecoration(
                      fillColor: Color(0xFFF5F5F5),
                      contentPadding: EdgeInsets.all(8),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.tag_faces)),
              SizedBox(
                height: 30,
                width: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero), elevation: MaterialStateProperty.all(0)),
                  onPressed: () {},
                  child: const Text('发送'),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        )
      ],
    );
  }
}
