import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hourglass/basic.dart';
import 'package:hourglass/page/watch/components/audience.dart';
import 'package:hourglass/page/watch/components/message_bubble.dart';
import 'package:hourglass/page/watch/controller.dart';
import 'package:hourglass/runtime.dart';
import 'package:provider/provider.dart';
import 'package:hourglass/helpers.dart';
import '../state.dart';

/// 聊天页面
class WatchChat extends StatefulWidget {
  const WatchChat({Key? key}) : super(key: key);

  @override
  State<WatchChat> createState() => _WatchChatState();
}

class _WatchChatState extends State<WatchChat> with WidgetsBindingObserver {
  FocusNode focusNode = FocusNode();
  double keyboardHeight = 260;
  ValueNotifier<KeyboardState> keyboard = ValueNotifier(KeyboardState.none);
  TextEditingController textEditingController = TextEditingController();
  ScrollController chatMessageController = ScrollController();

  /// only for chatMessageListener method
  late ChatState _chatState;
  late TabController tabController;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      tabController = context.read<WatchState>().tabController;

      tabController.addListener(switchTab);

      _chatState = context.read<ChatState>()..addListener(chatMessageListener);
    });

    super.initState();
  }

  @override
  void dispose() {
    tabController.removeListener(switchTab);

    _chatState.removeListener(chatMessageListener);

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bottom = MediaQuery.of(context).viewInsets.bottom;
    if (bottom == 0 && keyboard.value == KeyboardState.system) {
      keyboard.value = KeyboardState.none;
    } else if (bottom != 0) {
      keyboardHeight = bottom;
      keyboard.value = KeyboardState.system;
    }
  }

  switchTab() {
    if (tabController.index != 0) {
      focusNode.unfocus();
      if (keyboard.value == KeyboardState.emoji) {
        keyboard.value = KeyboardState.none;
      }
    }
  }

  chatMessageListener() {
    Future.delayed(Basic.animationDuration, (){
      if (_chatState.messages.isNotEmpty) {
        chatMessageController.animateTo(
          chatMessageController.position.maxScrollExtent,
          duration: Basic.animationDuration,
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<WatchController>();

    return Column(
      children: [
        /// 观众栏
        ValueListenableBuilder(
            valueListenable: keyboard,
            builder: (context, state, _) {
              return WatchAudience(expanded: state == KeyboardState.none);
            }),

        /// chat message list
        Expanded(
          child: ColoredBox(
            color: const Color(0xff29263a),
            child: Consumer<ChatState>(
              builder: (context, chat, _) {
                if (chat.messages.isEmpty) {
                  return const Default();
                }
                return ListView.builder(
                    itemCount: chat.messages.length,
                    controller: chatMessageController,
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    itemBuilder: (BuildContext context, int i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: MessageBubble(
                          chat.messages[i],
                          toRight: chat.messages[i].user == Runtime.instance.user,
                          // toRight: i % 2 == 0,
                        ),
                      );
                    });
              },
            ),
          ),
        ),

        /// message input bar
        ColoredBox(
          color: const Color(0xff1d1b29),
          child: SafeArea(
            top: false,
            maintainBottomViewPadding: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // IconButton(onPressed: () {}, icon: const Icon(Icons.keyboard_voice)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 0, 8),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      controller: textEditingController,
                      focusNode: focusNode,
                      maxLines: 3 + 1,
                      minLines: 1,
                      showCursor: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        fillColor: Color(0xff29263a),
                        contentPadding: EdgeInsets.all(8),
                        filled: true,
                        isDense: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    keyboard.value = keyboard.value != KeyboardState.emoji
                        ? KeyboardState.emoji
                        : KeyboardState.none;

                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  },
                  color: const Color(0xff9180d0),
                  icon: const Icon(Icons.tag_faces),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff6c24a2),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    elevation: 0,
                    minimumSize: Size.zero,
                  ),
                  onPressed: () =>
                      controller.sendMessage(textEditingController, chatMessageController),
                  child: const Text('发送'),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
        ValueListenableBuilder<KeyboardState>(
          valueListenable: keyboard,
          builder: (context, state, _) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: state == KeyboardState.none ? 0 : keyboardHeight,
              child: Opacity(
                opacity: state != KeyboardState.emoji ? 0 : 1,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
                  itemCount: 80,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, int index) {
                    return IconButton(
                      onPressed: () =>
                          textEditingController.inset(String.fromCharCode(128512 + index)),
                      icon: Text(
                        String.fromCharCode(128512 + index),
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

class Default extends StatelessWidget {
  const Default({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).size.width / 5;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Image.asset('assets/images/glasses.png'),
          ),
          const Text('快点击上方 + 邀请小伙伴进入吧', style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }
}
