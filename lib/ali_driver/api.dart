import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/ali_driver/request.dart';
import 'package:hourglass/model/db.dart';

class AliDriver {
  static final Request _request = Request(bearerToken: DB.accessToken);

  static const String _driveId = '8316645';

  static Future<List<AliFile>> fileList({String parentFileID = 'root'}) async {
    var response = await _request.post('https://api.aliyundrive.com/adrive/v3/file/list', data: {
      'all': false,
      'drive_id': DB.rootDriver,
      'fields': "*",
      'limit': 100,
      'order_by': "name",
      'order_direction': "ASC",
      'parent_file_id': parentFileID,
      'url_expire_sec': 1600,
      'video_thumbnail_process': "video/snapshot,t_1000,f_jpg,ar_auto,w_300",
    });
    var files = <AliFile>[];

    for(var f in response.body['items']){
      files.add(AliFile.formJson(f));
    }
    return files;
  }

  static refreshToken() {
    return _request.post('/token/refresh', data: {
      "refresh_token": "7c9a6d7deea7453bb60d6f4e2435569c",
    });
  }

  static videoPlayInfo() {
    return _request.post('/v2/file/get_video_preview_play_info', data: {
      "drive_id": "8316645",
      "file_id": "625d3e0af1ff1b5a7c1a4994a6f79db949d2a16a",
      "category": "live_transcoding",
      "template_id": "",
      "get_subtitle_info": true
    });
  }

  static get() {
    return _request.post('/v2/file/get_video_preview_play_info', data: {
      "drive_id": "8316645",
      "file_id": "625d3e0af1ff1b5a7c1a4994a6f79db949d2a16a",
      "category": "live_transcoding",
      "template_id": "",
      "get_subtitle_info": true
    });
  }
}
