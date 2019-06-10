import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/logic/wix_block_processor/wix_block_widget_creator.dart';
import 'package:mon_guide_musculation/utils/wix_utils.dart';

class WixBlockItem {
  Map<String, dynamic> rawContentJson;
  Map<String, dynamic> rawBlockJson;
  String text;
  String type;

  WixBlockItem({
    @required this.rawContentJson,
    @required this.rawBlockJson,
    this.text,
    this.type,
  });

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

@immutable
class WixBasicStatistics {
  final int totalComments;
  final int likeCount;
  final int viewCount;

  WixBasicStatistics({
    this.totalComments,
    this.likeCount,
    this.viewCount,
  });

  factory WixBasicStatistics.fromJson(Map<String, dynamic> data) {
    return WixBasicStatistics(
      totalComments: data["totalComments"] ?? -1,
      likeCount: data["likeCount"] ?? -1,
      viewCount: data["viewCount"] ?? -1,
    );
  }
}

/// Allow easy conversion bewteen basic Wix's Image Database entry formatted like:
/// wix:image://v1/<file>.jpg/<garbage>
@immutable
class WixImageReference {
  static final RegExp extractRegex = new RegExp(r"wix:image:\/\/v[\d]\/(.*?)\/");
  final String wixRessource;

  WixImageReference(
    this.wixRessource,
  ) : assert(wixRessource != null);

  /// Get a full url to the read file.
  String toFullUrl({Size resize}) {
    Match match = extractRegex.firstMatch(wixRessource);

    if (match != null) {
      String fullUrl = WixUtils.formatStaticWixImageUrl(match.group(1));

      if (resize != null) {
        fullUrl += "/v1/fit/w_" + resize.width.toInt().toString() + ",h_" + resize.height.toInt().toString() + ",al_c,q_90/image.jpg";
      }

      return fullUrl;
    }

    return null;
  }

  /// Safely create a [WixImageReference] instance of return null if the "data" parameter is null.
  static WixImageReference safe(String data) {
    return data != null ? WixImageReference(data) : null;
  }
}
