import 'package:flutter/material.dart';
import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/model/db.dart';
import 'package:hourglass/page/homepage/controller.dart';

class VideoSelector extends StatelessWidget {
  static const double coverSize = 40;

  const VideoSelector({Key? key}) : super(key: key);

  static open(BuildContext context) {
    Navigator.of(context).push(
      DialogRoute(
          context: context,
          builder: (BuildContext context) {
            return const VideoSelector();
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 1.5;
    var controller = HomepageController.getInstance()..context = context;

    return Align(
      alignment: Alignment.bottomCenter,
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 150),
        tween: Tween(begin: height, end: 0.0),
        builder: (BuildContext context, double value, Widget? child) {
          return Transform.translate(
            offset: Offset(0, value),
            child: child,
          );
        },
        child: Container(
          margin: const EdgeInsets.all(16.0),
          height: height,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Material(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: StreamBuilder(
                      stream: controller.fileListChangeNotifier.stream,
                      builder: (context, snapshot) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Visibility(
                              visible: controller.folderPaths.length != 1,
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.grey[800],
                                ),
                                iconSize: 18,
                                onPressed: controller.backToParentFolder,
                              ),
                            ),
                            TextButton(
                              onPressed: controller.playCurrentFolder,
                              child: const Text('播放全部'),
                            )
                          ],
                        );
                      }),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: controller.fileListChangeNotifier.stream,
                    builder: (BuildContext context, snapshot) {
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: controller.files.length,
                        itemBuilder: (BuildContext context, int i) {
                          var file = controller.files[i];

                          return ListTile(
                            onTap: () => controller.openFile(file),
                            leading: fileCover(file),
                            title: RichText(
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                                text: file.name,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget fileCover(AliFile file) {
    var widget = Image.network(
      width: coverSize,
      height: coverSize,
      fit: BoxFit.cover,
      file.thumbnail,
      headers: DB.originHeader,
    );
    if (!file.isVideo) {
      return widget;
    }
    return Stack(children: [
      widget,
      const Positioned.fill(
        child: Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: Color(0x4F9E9E9E),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: Icon(Icons.play_arrow),
          ),
        ),
      ),
    ]);
  }
}
