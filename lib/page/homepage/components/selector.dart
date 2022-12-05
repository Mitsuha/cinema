import 'package:flutter/material.dart';
import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/basic.dart';
import 'package:hourglass/page/homepage/controller.dart';
import 'package:hourglass/page/homepage/state.dart';
import 'package:provider/provider.dart';

class FileSelector extends StatelessWidget {
  static const double coverSize = 40;
  static const padding = 16.0;

  const FileSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var controller = context.read<HomepageController>();

    return Container(
      margin: const EdgeInsets.all(padding),
      height: size.height / 1.5,
      width: size.width - padding * 2,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Material(
        child: Consumer<HomepageState>(builder: (BuildContext context, state, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: state.folderPaths.length != 1,
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
                      onPressed: () => controller.playCurrentFolder(context),
                      child: const Text('播放全部'),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  addAutomaticKeepAlives: true,
                  padding: EdgeInsets.zero,
                  itemCount: state.files.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int i) {
                    var file = state.files[i];

                    return ListTile(
                      onTap: () => controller.openFile(context, file),
                      leading: fileCover(file),
                      title: Text(file.name, softWrap: false, overflow: TextOverflow.fade),
                    );
                  },
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Widget fileCover(AliFile file) {
    var widget = Image.network(
      width: coverSize,
      height: coverSize,
      fit: BoxFit.cover,
      file.thumbnail,
      headers: Basic.originHeader,
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
                color: Color(0x4F9E9E9E), borderRadius: BorderRadius.all(Radius.circular(50))),
            child: Icon(Icons.play_arrow),
          ),
        ),
      ),
    ]);
  }
}
