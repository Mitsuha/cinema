import 'package:flutter/material.dart';
import 'package:hourglass/model/user.dart';
import 'package:hourglass/page/homepage/components/profile_skeleton.dart';
import 'package:hourglass/page/homepage/state.dart';
import 'package:provider/provider.dart';
import 'package:hourglass/helpers.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomepageState state = context.watch<HomepageState>();

    if (! state.userInitial){
      return const UserProfileSkeleton();
    }
    context.read<User>().merge(state.user);

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(state.user.avatar),
              ),
              const SizedBox(height: 5),
              Text(state.user.name, style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 10),
              SizedBox(
                width: 180,
                child: Align(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${state.user.usedSize.toByteString()} / ${state.user.totalSize.toByteString()}',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.grey[200],
                          value: state.user.usedSize / state.user.totalSize,
                          minHeight: 5,
                          color: const Color(0xff7887d6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
