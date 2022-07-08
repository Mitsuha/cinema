class PlayInfo {
  final List<Source> sources;
  final double duration;
  final int width;
  final int height;

  PlayInfo({required this.sources,
    required this.duration,
    required this.width,
    required this.height});

  factory PlayInfo.formJson(json) =>
      PlayInfo(duration: json['meta']['duration'],
        width: json['meta']['width'],
        height: json['meta']['height'],
          sources: [
            for(var s in json['live_transcoding_task_list'])
              Source(url: s['url'], resolution: s['template_id'])
          ].reversed.toList()
      );
}

class Source {
  final String url;
  final String resolution;

  Source({required this.url, required this.resolution});

  get resolutionName => {"SD": "1080P 全高清","HD": "720P 标清","FHD": "540P 流畅",}[resolution];
}
