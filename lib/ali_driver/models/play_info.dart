import 'dart:convert';

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

  factory PlayInfo.formApiResponse(json) => PlayInfo(
      duration: json['meta']['duration'],
      width: json['meta']['width'],
      height: json['meta']['height'],
      sources: [for (var s in json['live_transcoding_task_list']) Source.formApiResponse(s)].reversed.toList(),
      subtitles: [for (var s in (json['live_transcoding_subtitle_task_list'] ?? [])) Subtitle.formJson(s)]);

  factory PlayInfo.formJson(json) => PlayInfo(
        duration: json['duration'],
        width: json['width'],
        height: json['height'],
        sources: [for (var s in json['sources']) Source(url: s['url'], resolution: s['resolution'])],
        subtitles: [],
      );

  Source get currentPlay => sources.where((element) => element.current).first;

  Source useSource(Source s) {
    for (var element in sources) {
      element.current = false;
      if (element.url == s.url) {
        element.current = true;
      }
    }
    return s;
  }

  Source useTheBast() {
    return useSource(sources.first);
  }

  Subtitle useSubtitle(Subtitle s) {
    for (var element in subtitles) {
      element.current = false;
      if (element.url == s.url) {
        element.current = true;
      }
    }
    return s;
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'width': width,
      'height': height,
      'sources': [
        for (var s in sources) s.toJson(),
      ],
    };
  }
}

class Source {
  final String url;
  final String resolution;
  bool current = false;

  Source({required this.url, required this.resolution});

  factory Source.formJson(json) => Source(url: json['url'], resolution: json['resolution']);

  factory Source.formApiResponse(json) => Source(url: json['url'], resolution: json['template_id']);

  get resolutionSort =>
      {
        "LD": "?????????",
        "SD": "??????",
        "HD": "??????",
        "FHD": "??????",
      }[resolution] ??
      '??????';

  get resolutionFullName {
    return {
          "LD": "360P ???????????????",
          "SD": "540P ??????",
          "HD": "720P ??????",
          "FHD": "1080P ??????",
        }[resolution] ??
        resolution;
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'resolution': resolution,
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
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
