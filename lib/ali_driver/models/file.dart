import 'package:hourglass/ali_driver/models/play_info.dart';

import '../api.dart';

class AliFile {
  final int size;
  final String driveID;
  final String fileID;
  final String name;
  final String parentFileID;
  final String type;
  final String updatedAt;
  final String category;
  final String thumbnail;
  final DateTime createdAt;
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
    required this.size,
    this.playInfo,
    this.videoMetadata,
  });

  factory AliFile.formJson(json) => AliFile(
        size: json['size'] ?? 0,
        driveID: json['drive_id'] ?? '',
        fileID: json['file_id'],
        name: json['name'],
        parentFileID: json['parent_file_id'] ?? '',
        type: json['type'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'],
        category: json['category'] ?? 'file',
        thumbnail: json['thumbnail'] ??
            (json['category'] == null // is file?
                ? 'https://img.alicdn.com/imgextra/i3/O1CN01qSxjg71RMTCxOfTdi_!!6000000002097-2-tps-80-80.png'
                : 'https://img.alicdn.com/imgextra/i1/O1CN01mhaPJ21R0UC8s9oik_!!6000000002049-2-tps-80-80.png'),
        playInfo: json['play_info'] == null ? null : PlayInfo.formJson(json['play_info']),
        videoMetadata: json['video_media_metadata'] == null
            ? null
            : VideoMetadata(
                width: json['video_media_metadata']['width'] ?? 1920,
                height: json['video_media_metadata']['height'] ?? 1080,
              ),
      );

  get isFolder => category == 'file';

  get isVideo => category == 'video';

  get playInfoLoaded => playInfo != null;

  Future<AliFile> loadPlayInfo() async {
    playInfo = await AliDriver.videoPlayInfo(fileID);

    return this;
  }

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'file_id': fileID,
      'name': name,
      'type': type,
      'updated_at': updatedAt,
      'category': category,
      'thumbnail': thumbnail,
      'created_at': createdAt.toString(),
      'play_info': playInfo?.toJson(),
      'video_media_metadata': videoMetadata?.toJson(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AliFile && runtimeType == other.runtimeType && fileID == other.fileID;

  @override
  int get hashCode => fileID.hashCode;
}

class VideoMetadata {
  final int width;
  final int height;

  const VideoMetadata({required this.width, required this.height});

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
    };
  }
}
