import 'package:flutter/material.dart';
import 'package:hourglass/model/db.dart';
import 'package:hourglass/page/homepage/controller.dart';

class VideoSelector extends StatelessWidget {
  const VideoSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height / 1.5;
    var controller = HomepageController.getInstance();

    return Container(
      margin: const EdgeInsets.all(16.0),
      height: height,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [TextButton(onPressed: () {}, child: const Text('播放全部'))],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: controller.fileListChangeNotifier.stream,
              builder: (BuildContext context, snapshot) {
                return Material(
                  color: Colors.white,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.files.length,
                    itemBuilder: (BuildContext context, int i) {
                      var file = controller.files[i];

                      return ListTile(
                        onTap: () {},
                        leading: Image.network(
                          height: 30,
                          file.thumbnail,
                          headers: DB.originHeader,
                        ),
                        title: Text(
                          file.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
