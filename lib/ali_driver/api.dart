import 'package:hourglass/ali_driver/models/file.dart';
import 'package:hourglass/ali_driver/models/play_info.dart';
import 'package:hourglass/ali_driver/request.dart';
import 'package:hourglass/ali_driver/persistence.dart';

class AliDriver {
  static Request _request = Request(bearerToken: AliPersistence.instance.accessToken);

  static Future<List<AliFile>> fileList({String parentFileID = 'root'}) async {
    var response = await _request.post('/adrive/v3/file/list', data: {
      'all': false,
      'drive_id': AliPersistence.instance.rootDriver,
      'fields': "*",
      'limit': 100,
      'order_by': "name",
      'order_direction': "ASC",
      'parent_file_id': parentFileID,
      'url_expire_sec': 1600,
      'video_thumbnail_process': "video/snapshot,t_1000,f_jpg,ar_auto,w_300",
    });
    var files = <AliFile>[];

    for (var f in response.body['items']) {
      files.add(AliFile.formJson(f));
    }
    return files;
  }

  static Future<void> refreshToken() async {
    var response = await _request.post('/token/refresh', data: {
      "refresh_token": AliPersistence.instance.refreshToken,
    });

    AliPersistence.instance.accessToken = response.body['access_token'];
    _request = Request(bearerToken: AliPersistence.instance.accessToken);
  }

  static Future<PlayInfo> videoPlayInfo(String fileID) async {
    var response = await _request.post('/v2/file/get_video_preview_play_info', data: {
      "drive_id": AliPersistence.instance.rootDriver,
      "file_id": fileID,
      "category": "live_transcoding",
      "template_id": "",
      "get_subtitle_info": true,
      "url_expire_sec": 14400
    });

    return PlayInfo.formApiResponse(response.body['video_preview_play_info']);
  }

  static downloadUrl(String fileID) {
    return _request.post('/v2/file/get_download_url', data: {
      "drive_id": AliPersistence.instance.rootDriver,
      "file_id": fileID
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

  static Future<Response> userProfile() {
    return _request.post('/adrive/v2/user/get', data: {});
  }

  static Future<Response> userDriverInfo() {
    return _request.post('/v2/databox/get_personal_info', data: {});
  }
}
