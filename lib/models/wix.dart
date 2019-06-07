import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/logic/wix_block_processor/wix_block_widget_creator.dart';

class WixBlockItem {
  Map<String, dynamic> rawContentJson;
  Map<String, dynamic> rawBlockJson;
  String text;
  String type;

  WixBlockItem({@required this.rawContentJson, @required this.rawBlockJson, this.text, this.type});

  factory WixBlockItem.fromJson(Map<String, dynamic> baseContent, Map<String, dynamic> data) {
    String text = data["text"];
    String type = data["type"];

    if (text == "" && (type == "unstyled" || type.startsWith("header-"))) {
      return null;
    }

    return WixBlockItem(
      rawContentJson: baseContent,
      rawBlockJson: data,
      text: text,
      type: type,
    );
  }

  /// Shortcut for [WixBlockWidgetCreator.toWidget(context, item)].
  Widget toWidget(BuildContext context) {
    return WixBlockWidgetCreator.toWidget(context, this);
  }

  bool isTitle() {
    return type.startsWith("header-");
  }
}

class WixBasicStatistics {
  int totalComments;
  int likeCount;
  int viewCount;

  WixBasicStatistics({this.totalComments, this.likeCount, this.viewCount});

  factory WixBasicStatistics.fromJson(Map<String, dynamic> data) {
    return WixBasicStatistics(
      totalComments: data["totalComments"] ?? -1,
      likeCount: data["likeCount"] ?? -1,
      viewCount: data["viewCount"] ?? -1,
    );
  }
}
