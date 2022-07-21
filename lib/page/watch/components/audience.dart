import 'package:flutter/material.dart';
import 'package:hourglass/basic.dart';
import 'package:hourglass/page/watch/controller.dart';
import 'package:provider/provider.dart';
import '../state.dart';

class WatchAudience extends StatelessWidget {
  const WatchAudience({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = context.watch<WatchState>();
    var controller = context.read<WatchController>();

    return SizedBox(
      height: 75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 11, top: 8, bottom: 5),
            child: Text('当前 ${state.room.users.length} 人'),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                for (var user in state.room.users)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: CircleAvatar(backgroundImage: NetworkImage(user.avatar, headers: Basic.originHeader)),
                  ),
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: IconButton(onPressed: () => controller.invitationPopup(context), icon: Icon(Icons.add, color: Colors.grey[600])),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
