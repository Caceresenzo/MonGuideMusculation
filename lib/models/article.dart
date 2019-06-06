import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/logic/article_processor/article_widget_creator.dart';
import 'package:mon_guide_musculation/utils/constants.dart';

class WebArticle {
  String slug;
  String author;
  String authorProfilePictureSource;
  String releaseDate;
  String readingTimeEstimation;
  String title;
  String seoDescription;
  int viewCount;
  int likeCount;
  int totalComments;
  String coverImageSource;
  ArticleContent content;

  WebArticle({this.slug, this.author, this.authorProfilePictureSource, this.releaseDate, this.readingTimeEstimation, this.title, this.seoDescription, this.viewCount, this.likeCount, this.totalComments, this.coverImageSource, @required this.content});

  factory WebArticle.fromJson(Map<String, dynamic> json) {
    return WebArticle(
      slug: json['slug'],
      author: json['owner']['name'],
      authorProfilePictureSource: json['owner']['image']['file_name'],
      title: json['title'].replaceAll(new RegExp(r'\n'), ''),
      seoDescription: json['seoDescription'], // ?? "<no desc>",
      viewCount: json['viewCount'],
      likeCount: json['likeCount'],
      totalComments: json['totalComments'],
      coverImageSource: json['coverImage']["src"]["file_name"],
      content: ArticleContent.fromJson(null, json),
    );
  }

  String toRemoteUrl() {
    return Constants.formatStaticWixPostUrl(slug);
  }
}

class ArticleContent {
  WebArticle parentArticle;
  List<ArticleContentItem> items;

  ArticleContent({@required this.parentArticle, this.items});

  factory ArticleContent.fromJson(WebArticle parent, Map<String, dynamic> data) {
    List<ArticleContentItem> items = [];

    Map<String, dynamic> content = data["content"];
    List<dynamic> blocks = content["blocks"];

    blocks.forEach((block) {
      var contentItem = ArticleContentItem.fromJson(content, block);

      if (contentItem != null) {
        items.add(contentItem);
      }
    });

    return ArticleContent(
      parentArticle: parent,
      items: items,
    );
  }
}

class ArticleContentItem {
  Map<String, dynamic> rawContentJson;
  Map<String, dynamic> rawBlockJson;
  String text;
  String type;

  ArticleContentItem({@required this.rawContentJson, @required this.rawBlockJson, this.text, this.type});

  factory ArticleContentItem.fromJson(Map<String, dynamic> baseContent, Map<String, dynamic> data) {
    String text = data["text"];
    String type = data["type"];

    if (text == "" && (type == "unstyled" || type.startsWith("header-"))) {
      return null;
    }

    return ArticleContentItem(
      rawContentJson: baseContent,
      rawBlockJson: data,
      text: text,
      type: type,
    );
  }

  /// Shortcut for [ArticleWidgetCreator.toWidget(context, item)].
  Widget toWidget(BuildContext context) {
    return ArticleWidgetCreator.toWidget(context, this);
  }

  bool isTitle() {
    return type.startsWith("header-");
  }

}
