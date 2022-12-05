import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hourglass/ali_driver/persistence.dart';
import 'package:hourglass/basic.dart';
import 'package:hourglass/model/version.dart';
import 'package:hourglass/page/upgrade.dart';
import 'package:hourglass/page/welcome/welcome.dart';
import 'package:hourglass/runtime.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'homepage/homepage.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    autoUpgrade(context);

    var persistence = context.watch<AliPersistence>();

    if (persistence.initState == AliDriverInitState.initialing) {
      return const Material(
        color: Colors.white,
        child: Center(
          child: Text('少女祈祷中...'),
        ),
      );
    }

    if (persistence.initState == AliDriverInitState.fail) {
      return const Welcome();
    }

    return const Homepage();
  }

  void autoUpgrade(BuildContext context) async {
    if (Runtime.instance.newVersionChecked) {
      return;
    }
    Runtime.instance.newVersionChecked = true;

    var objects = await Future.wait([
      PackageInfo.fromPlatform(),
      HttpClient().getUrl(Uri.parse("http://${Basic.remoteAddress}/version")),
    ]);

    var packageInfo = objects.first as PackageInfo;

    var request = objects.last as HttpClientRequest;

    var response = await request.close();

    var body = await response.transform(utf8.decoder).join();

    var version = Version.fromJson(jsonDecode(body));

    if (version.buildNumber > int.parse(packageInfo.buildNumber)) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (builder) {
            return UpgradeView(version);
          });
    }
  }
}
