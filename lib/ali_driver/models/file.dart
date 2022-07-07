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
      );

  get isFolder => category == 'file';
  get isVideo => category == 'video';
}
