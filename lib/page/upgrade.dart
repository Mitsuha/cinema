import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hourglass/model/version.dart';
// import 'package:url_launcher/url_launcher.dart';

class UpgradeView extends StatefulWidget {
  final Version version;

  const UpgradeView(this.version, {Key? key}) : super(key: key);

  @override
  State<UpgradeView> createState() => _UpgradeViewState();
}

class _UpgradeViewState extends State<UpgradeView> {
  DateTime _lastTapBack = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!widget.version.forcibly) {
          return true;
        }

        if (DateTime.now().difference(_lastTapBack) > const Duration(seconds: 1)) {
          _lastTapBack = DateTime.now();
          Fluttertoast.showToast(msg: '再按一次退出');
          return false;
        }
        SystemNavigator.pop();
        return true;
      },
      child: AlertDialog(
        title: const Text('有新的版本'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('最新版本：${widget.version.version}'),
            const Text('更新内容：'),
            Text(widget.version.description)
          ],
        ),
        actions: [
          if (!widget.version.forcibly)
            TextButton(
              onPressed: close,
              child: const Text('下次再说', style: TextStyle(color: Colors.grey)),
            ),
          TextButton(onPressed: openBrowser, child: const Text('更新'))
        ],
      ),
    );
  }

  close() {
    Navigator.of(context).pop();
  }

  openBrowser() {
    // launchUrl(Uri.parse(widget.version.downloadUrl),
    //     mode: LaunchMode.externalNonBrowserApplication);
  }
}
