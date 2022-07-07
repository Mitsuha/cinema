class Video {
  final List<Source> sources;
  final double duration;
  final int width;
  final int height;

  Video({required this.sources,
    required this.duration,
    required this.width,
    required this.height});

  factory Video.formJson(json) =>
      Video(duration: json['meta']['duration'],
        width: json['meta']['width'],
        height: json['meta']['height'],
          sources: [
            for(var s in json['live_transcoding_task_list'])
              Source(url: s['url'], resolution: s['template_id'])
          ]
      );
}

class Source {
  final String url;
  final String resolution;

  Source({required this.url, required this.resolution});
}
