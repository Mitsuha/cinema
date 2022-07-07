import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;

  const CardItem(
      {required this.icon,
      required this.title,
      required this.subtitle,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 20),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(subtitle,
                    style: const TextStyle(fontSize: 11, color: Colors.grey))
              ],
            )
          ],
        ));
  }
}
