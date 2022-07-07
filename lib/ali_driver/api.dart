import 'package:hourglass/ali_driver/request.dart';

class AliDriver{
  static const token = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJmZjkxNDRjZDA4MTY0YTIyYjgzNzZkMmVkMWZmMDFjZCIsImN1c3RvbUpzb24iOiJ7XCJjbGllbnRJZFwiOlwiMjVkelgzdmJZcWt0Vnh5WFwiLFwiZG9tYWluSWRcIjpcImJqMjlcIixcInNjb3BlXCI6W1wiRFJJVkUuQUxMXCIsXCJTSEFSRS5BTExcIixcIkZJTEUuQUxMXCIsXCJVU0VSLkFMTFwiLFwiVklFVy5BTExcIixcIlNUT1JBR0UuQUxMXCIsXCJTVE9SQUdFRklMRS5MSVNUXCIsXCJCQVRDSFwiLFwiT0FVVEguQUxMXCIsXCJJTUFHRS5BTExcIixcIklOVklURS5BTExcIixcIkFDQ09VTlQuQUxMXCIsXCJTWU5DTUFQUElORy5MSVNUXCIsXCJTWU5DTUFQUElORy5ERUxFVEVcIl0sXCJyb2xlXCI6XCJ1c2VyXCIsXCJyZWZcIjpcImh0dHBzOi8vd3d3LmFsaXl1bmRyaXZlLmNvbS9cIixcImRldmljZV9pZFwiOlwiNzdiZGVjMWUzZjQ4NGFjY2JmNGY2NWVlMmVkMWNmY2VcIn0iLCJleHAiOjE2NTcwMTg3NzEsImlhdCI6MTY1NzAxMTUxMX0.A5iQ2g08tRwOZuN2Ftai7uFrJDetWrJDc1hsVlXvUAMiwDoMxrJqlU_gzRbyAzysiunVgdvukWLBzM5fxvOalt3DY7U4H39zy4HWt6dfQOO00NJfX3cYYVAClI2v-qkKNwhuYqx2TXPo3ARZ2mpVY2ymylhTVw4_Bi9cZHNrKVY';

  static final Request _request = Request(bearerToken: token);

  static const String _driveId = '8316645';

  static fileList({String parentFileID = 'root'}){
    _request.post('https://api.aliyundrive.com/adrive/v3/file/list', data: {
      'all' : false,
      'drive_id' : "8316645",
      'fields' : "*",
      'limit' : 100,
      'order_by' : "updated_at",
      'order_direction' : "DESC",
      'parent_file_id' : "625d3e0af360abcd8f8f4ad183764654c3882973",
      'url_expire_sec' : 1600,
      'video_thumbnail_process' : "video/snapshot,t_1000,f_jpg,ar_auto,w_300",
    }).then((value) => print(value.body['items'][0]['url']));
  }

  static refreshToken(){
    return _request.post('/token/refresh', data: {
      "refresh_token": "7c9a6d7deea7453bb60d6f4e2435569c",
    });
  }

  static videoPlayInfo(){
    return _request.post('/v2/file/get_video_preview_play_info', data: {
      "drive_id": "8316645",
      "file_id": "625d3e0af1ff1b5a7c1a4994a6f79db949d2a16a",
      "category": "live_transcoding",
      "template_id": "",
      "get_subtitle_info": true
    });
  }

  static get(){
    return _request.post('/v2/file/get_video_preview_play_info', data: {
      "drive_id": "8316645",
      "file_id": "625d3e0af1ff1b5a7c1a4994a6f79db949d2a16a",
      "category": "live_transcoding",
      "template_id": "",
      "get_subtitle_info": true
    });
  }
}