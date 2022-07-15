import 'package:flutter/material.dart';
import 'package:hourglass/page/watch/components/audience.dart';

class WatchChat extends StatelessWidget {
  const WatchChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        WatchAudience()
      ],
    );
  }
}
