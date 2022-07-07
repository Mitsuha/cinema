import 'package:flutter/material.dart';

import '../../../model/db.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                backgroundImage: NetworkImage(
                    DB.avatar != '' ? DB.avatar : DB.defaultAvatar),
              ),
              const SizedBox(height: 5),
              Text(DB.name, style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 10),
              SizedBox(
                width: 180,
                child: Align(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('668.11 GB / 90.11 GB',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 3),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.grey[200],
                          value: 0.5,
                          minHeight: 8,
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
