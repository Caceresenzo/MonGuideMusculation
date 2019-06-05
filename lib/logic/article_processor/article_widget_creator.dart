import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/models/article.dart';
import 'package:mon_guide_musculation/ui/widgets/common_divider.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:mon_guide_musculation/utils/functions.dart';
import 'package:youtube_player/youtube_player.dart';

class ArticleWidgetCreator {
  static int _orderedListCounter = 1;
  static List<String> _numbers = ["one", "two", "three", "four", "five", "six"];

  static Widget toWidget(BuildContext context, ArticleContentItem item) {
    return Container(
      child: Padding(padding: EdgeInsets.fromLTRB(8, 2, 8, 2), child: _createByType(context, item) ?? Text("???")),
    );
  }

  static Widget _createByType(BuildContext context, ArticleContentItem item) {
    switch (item.type) {
      case "atomic":
        return _createAtomic(context, item);

      default:
        return _createFormatted(context, item);
    }
  }

  static Widget _createAtomic(BuildContext context, ArticleContentItem item) {
    String entityId = item.rawBlockJson["entityRanges"][0]["key"].toString();
    Map<String, dynamic> entity = item.rawContentJson["entityMap"][entityId];

    String entityType = entity["type"];

    switch (entityType) {
      case WixData.typeAtomicLink:
        return Text("LINK NOT SUPPORTED");

      case WixData.typeAtomicImage:
        String fileName = entity["data"]["src"]["file_name"];

        return networkImage(Constants.formatStaticWixImageUrl(fileName));

      case WixData.typeAtomicDevider:
        return CommonDivider();

      case WixData.typeAtomicVideo:
        String youtubeLink = entity["data"]["src"];

        return YoutubePlayer(
          context: context,
          source: youtubeLink,
          quality: YoutubeQuality.HIGH,
          autoPlay: false,
          showThumbnail: true,
        );

      default:
        return Text("Unknown atomic type: " + entityType);
    }
  }

  static Widget _createFormatted(BuildContext context, ArticleContentItem item) {
    if (item.type != "ordered-list-item") {
      /* Reset */
      _orderedListCounter = 0;
    }

    if (item.isTitle()) {
      String number = item.type.substring(7, item.type.length);
      double numeric = 1.0 + _numbers.indexOf(number);

      return Text(
        item.text.toUpperCase(),
        style: TextStyle(
          fontSize: 20.0 - numeric,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      );
    }

    switch (item.type) {
      case "ordered-list-item":
        _orderedListCounter = _orderedListCounter + 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "\t\t\t" + _orderedListCounter.toString() + ".\t",
              style: TextStyle(fontSize: 12.0),
              textAlign: TextAlign.justify,
            ),
            Expanded(
              child: Text(
                item.text,
                style: TextStyle(fontSize: 12.0),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        );

      case "unordered-list-item":
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "\t\t\t\u25CF\t",
              style: TextStyle(fontSize: 12.0 - 3),
              textAlign: TextAlign.justify,
            ),
            Expanded(
              child: Text(
                item.text,
                style: TextStyle(fontSize: 12.0),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        );

      case "blockquote":
        return Container(
          child: Text(
            item.text,
            style: TextStyle(fontStyle: FontStyle.italic),
            textAlign: TextAlign.justify,
          ),
          padding: EdgeInsets.only(
            left: 5.0,
          ),
          decoration: new BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Constants.colorAccent,
                width: 4.0,
              ),
            ),
          ),
        );

      default:
        return Text(
          item.text,
          style: TextStyle(fontSize: 12),
          textAlign: TextAlign.justify,
        );
    }
  }
}
