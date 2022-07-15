class PlayInfo {
  final double duration;
  final int width;
  final int height;
  final List<Source> sources;
  final List<Subtitle> subtitles;

  PlayInfo(
      {required this.sources,
      required this.duration,
      required this.width,
      required this.height,
      required this.subtitles});

  Source get currentPlay => sources.where((element) => element.current).first;

  Source useSource(Source s) {
    for (var element in sources) {
      element.current = false;
      if(element.url == s.url){
        element.current = true;
      }
    }
    return s;
  }

  Source useTheBast() {
    return useSource(sources.first);
  }

  Subtitle useSubtitle(Subtitle s){
    for (var element in subtitles) {
      element.current = false;
      if(element.url == s.url){
        element.current = true;
      }
    }
    return s;
  }

  factory PlayInfo.formJson(json) => PlayInfo(
      duration: json['meta']['duration'],
      width: json['meta']['width'],
      height: json['meta']['height'],
      sources: [for (var s in json['live_transcoding_task_list']) Source(url: s['url'], resolution: s['template_id'])]
          .reversed
          .toList(),
      subtitles: [for (var s in (json['live_transcoding_subtitle_task_list'] ?? [])) Subtitle.formJson(s)]);
}

class Source {
  final String url;
  final String resolution;
  bool current = false;

  Source({required this.url, required this.resolution});

  get resolutionSort =>
      {
        "LD": "低画质",
        "SD": "流畅",
        "HD": "标清",
        "FHD": "高清",
      }[resolution] ??
      '原画';

  get resolutionFullName {
    return {
          "LD": "360P 不是人看的",
          "SD": "540P 流畅",
          "HD": "720P 标清",
          "FHD": "1080P 高清",
        }[resolution] ??
        resolution;
  }
}

class Subtitle {
  final String language;
  final String status;
  final String url;

  bool current = false;

  Subtitle({required this.language, required this.status, required this.url});

  factory Subtitle.formJson(json) => Subtitle(language: json['language'], status: json['status'], url: json['url']);
}
