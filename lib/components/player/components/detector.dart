import 'package:flutter/material.dart';
import '../controller.dart';
import 'package:provider/provider.dart';

class PlayerDetector extends StatelessWidget {
  const PlayerDetector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlayerController controller = context.read<PlayerController>();

    return GestureDetector(
      onTap: controller.switchRibbon,
      onDoubleTap: controller.switchPlayStatus,
      onHorizontalDragUpdate: controller.addFastForwardTo,
      onHorizontalDragEnd: controller.doFastForward,
      onHorizontalDragCancel: controller.onDetectorDone,
      onVerticalDragEnd: controller.addBrightOrVolumeDone,
      onVerticalDragCancel: controller.onDetectorDone,
      onVerticalDragUpdate: (DragUpdateDetails details) {
        var half = MediaQuery.of(context).size.width / 2;

        if (details.globalPosition.dx > half) {
          controller.addVolume(details);
        } else {
          controller.addBright(details);
        }
      },
    );
  }
}
