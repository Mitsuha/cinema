import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hourglass/basic.dart';
import 'package:hourglass/page/watch/controller.dart';
import 'package:hourglass/page/watch/state.dart';
import 'package:provider/provider.dart';

/// 观众栏
class WatchAudience extends StatelessWidget {
  final bool expanded;

  const WatchAudience({required this.expanded, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var users = context.watch<WatchState>().room.users;

    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 500),
      crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
      firstChild: ConstrainedBox(
        constraints: const BoxConstraints.expand(height: 0),
        child: const ColoredBox(color: Color(0xff1d1b29)),
      ),
      secondChild: ColoredBox(
        color: const Color(0xff1d1b29),
        child: SizedBox(
          height: 60,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            children: [
              for (var user in users)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ClipOval(
                    child: Image.network(user.avatar, headers: Basic.originHeader),
                  ),
                ),
              DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => buildInvitationPopup(context),
                  icon: Icon(Icons.add, color: Colors.grey[600], size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildInvitationPopup(BuildContext context) {
    var controller = context.read<WatchController>();

    if (controller.state.room.id == 0) {
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var shareText = controller.shareText;
        const style = TextStyle(color: Colors.white);

        return AlertDialog(
          title: const Text('邀请朋友', style: style),
          content: Text(shareText, style: style),
          backgroundColor: const Color(0xff151515),
          actions: [
            TextButton(
              child: const Text('取消', style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('复制'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: shareText)).then((_) {
                  Fluttertoast.showToast(msg: '已复制到剪切板');
                });
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
