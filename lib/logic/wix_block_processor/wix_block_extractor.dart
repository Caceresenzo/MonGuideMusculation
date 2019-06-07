import 'package:mon_guide_musculation/models/wix.dart';

class WixBlockExtractor {

  static List<WixBlockItem> extractFromJson(Map<String, dynamic> content) {
    List<WixBlockItem> items = [];

    List<dynamic> blocks = content["blocks"];

    blocks.forEach((block) {
      var contentItem = WixBlockItem.fromJson(content, block);

      if (contentItem != null) {
        items.add(contentItem);
      }
    });

    return items;
  }

}
