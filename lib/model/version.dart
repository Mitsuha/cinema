class Version {
  final String version;
  final int buildNumber;
  final String description;
  final String downloadUrl;
  final bool forcibly;

  Version({
    required this.version,
    required this.buildNumber,
    required this.description,
    required this.downloadUrl,
    required this.forcibly,
  });

  factory Version.fromJson(Map<String, dynamic> json) => Version(
        version: json['version'],
        buildNumber: json['buildNumber'],
        description: json['description'],
        downloadUrl: json['downloadUrl'],
        forcibly: json['forcibly'],
      );
}
