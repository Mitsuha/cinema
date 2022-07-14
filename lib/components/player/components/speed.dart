import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller.dart';

class SelectSpeed extends StatelessWidget {
  const SelectSpeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlayerController controller = context.read<PlayerController>();

    double speed = controller.playerController?.value.playbackSpeed ?? 1;

    const TextStyle normal = TextStyle(color: Colors.white);
    const TextStyle active = TextStyle(color: Color(0xffff889c));

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            child: Text('1x', style: speed == 1 ? active : normal),
            onPressed: () => controller.setPlaySpeed(1),
          ),
          TextButton(
            child: Text('1.25x', style: speed == 1.25 ? active : normal),
            onPressed: () => controller.setPlaySpeed(1.25),
          ),
          TextButton(
            child: Text('1.5x', style: speed == 1.5 ? active : normal),
            onPressed: () => controller.setPlaySpeed(1.5),
          ),
          TextButton(
            child: Text('2x', style: speed == 2 ? active : normal),
            onPressed: () => controller.setPlaySpeed(2),
          ),
          TextButton(
            child: Text('3x', style: speed == 3 ? active : normal),
            onPressed: () => controller.setPlaySpeed(3),
          ),
        ],
      ),
    );
  }
}
