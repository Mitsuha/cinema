import 'package:flutter/material.dart';

class PlayerMenu extends StatelessWidget {
  const PlayerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widgetSize = MediaQuery.of(context).size;
    return SizedBox(
      width: widgetSize.width / 3,
      height: widgetSize.height,
      child: const Material(
        color: Color(0x80000000),
        child: Center(),
      ),
    );
  }
}
