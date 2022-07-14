class PlayInfo {
  final List<Source> sources;
  final double duration;
  final int width;
  final int height;

  PlayInfo({required this.sources, required this.duration, required this.width, required this.height});

  Source get currentPlay => sources.where((element) => element.current).first;

  Source use(int i) {
    for (var element in sources) {
      element.current = false;
    }

    return sources[i]..current = true;
  }

  Source useTheBast(){
    return use(0);
  }

  factory PlayInfo.formJson(json) => PlayInfo(
      duration: json['meta']['duration'],
      width: json['meta']['width'],
      height: json['meta']['height'],
      sources: [for (var s in json['live_transcoding_task_list']) Source(url: s['url'], resolution: s['template_id'])]
          .reversed
          .toList());
}

class Source {
  final String url;
  final String resolution;
  bool current = false;

  Source({required this.url, required this.resolution});

  get resolutionSort => {
        "LD": "低画质",
        "SD": "流畅",
        "HD": "标清",
        "FHD": "高清",
      }[resolution] ?? '原画';

  get resolutionFullName {
    return {
        "LD": "360P 不是人看的",
        "SD": "540P 流畅",
        "HD": "720P 标清",
        "FHD": "1080P 高清",
      }[resolution] ?? resolution;
  }
}
