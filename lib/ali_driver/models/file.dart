import 'package:flutter/cupertino.dart';
import 'package:hourglass/ali_driver/models/play_info.dart';

import '../api.dart';

class AliFile {
  final String driveID;
  final String fileID;
  final String name;
  final String parentFileID;
  final String type;
  final String updatedAt;
  final String createdAt;
  final String category;
  final String thumbnail;
  PlayInfo? playInfo;
  VideoMetadata? videoMetadata;

  AliFile({
    required this.driveID,
    required this.fileID,
    required this.name,
    required this.parentFileID,
    required this.type,
    required this.updatedAt,
    required this.createdAt,
    required this.category,
    required this.thumbnail,
    this.videoMetadata,
  });

  factory AliFile.formJson(json) => AliFile(
        driveID: json['drive_id'],
        fileID: json['file_id'],
        name: json['name'],
        parentFileID: json['parent_file_id'],
        type: json['type'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        category: json['category'] ?? 'file',
        thumbnail: json['thumbnail'] ??
            (json['category'] == null // is file?
                ? 'https://img.alicdn.com/imgextra/i3/O1CN01qSxjg71RMTCxOfTdi_!!6000000002097-2-tps-80-80.png'
                : 'https://img.alicdn.com/imgextra/i1/O1CN01mhaPJ21R0UC8s9oik_!!6000000002049-2-tps-80-80.png'),
        videoMetadata: json['video_media_metadata'] == null
            ? null
            : VideoMetadata(
                width: json['video_media_metadata']['width'],
                height: json['video_media_metadata']['height'],
              ),
      );

  get isFolder => category == 'file';

  get isVideo => category == 'video';

  get playInfoLoaded => playInfo != null;

  Future<AliFile> loadPlayInfo() async {
    playInfo = await AliDriver.videoPlayInfo(fileID);

    return this;
  }
}

class VideoMetadata {
  final int width;
  final int height;

  const VideoMetadata({required this.width, required this.height});
}
