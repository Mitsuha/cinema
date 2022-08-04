import 'package:flutter/material.dart';
import 'package:hourglass/basic.dart';
import 'package:hourglass/model/user.dart';
import 'package:hourglass/page/watch/controller.dart';
import 'package:provider/provider.dart';

class WatchAudience extends StatelessWidget {
  final List<User> users;

  const WatchAudience(this.users, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = context.read<WatchController>();

    return SizedBox(
      height: 50,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        children: [
          for (var user in users)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: DecoratedBox(
                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30))),
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
              onPressed: () => controller.invitationPopup(context),
              icon: Icon(Icons.add, color: Colors.grey[600], size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
