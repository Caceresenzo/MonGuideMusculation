import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mon_guide_musculation/logic/article_processor/article_widget_creator.dart';
import 'package:mon_guide_musculation/ui/widgets/common_divider.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_player/youtube_player.dart';

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
      seoDescription: json['seoDescription'],
      viewCount: json['viewCount'],
      likeCount: json['likeCount'],
      totalComments: json['totalComments'],
      coverImageSource: json['coverImage']["src"]["file_name"],
      content: ArticleContent.fromJson(null, json),
    );
  }

  static Future<List<WebArticle>> fetchPost() async {
    final response = await http.get('https://social-blog.wix.com/?compId=TPASection_jav3el7a&currency=EUR&dateNumberFormat=fr-fr&deviceType=desktop&height=1738&instance=S4Z6TuF8eiI1wsxFg4f1dJUlWHAFvkZQvyr-UD6--8I.eyJpbnN0YW5jZUlkIjoiYmU4YzE4OTctN2ZmZS00MWYxLWI1MGItZWEzYTIwMTczMGVhIiwiYXBwRGVmSWQiOiIxNGJjZGVkNy0wMDY2LTdjMzUtMTRkNy00NjZjYjNmMDkxMDMiLCJtZXRhU2l0ZUlkIjoiNWVlNzI5ODUtMGQ1Ny00YWU0LWI5YjgtYzFlZjJmY2VhMjc4Iiwic2lnbkRhdGUiOiIyMDE5LTA2LTA0VDE5OjU2OjMxLjI2OVoiLCJ1aWQiOm51bGwsImlwQW5kUG9ydCI6Ijg4LjEyNS4yMTQuNDMvNTIwMTQiLCJ2ZW5kb3JQcm9kdWN0SWQiOm51bGwsImRlbW9Nb2RlIjpmYWxzZSwib3JpZ2luSW5zdGFuY2VJZCI6IjhkZjRkODMzLTUxNWQtNDAxMy05ZmNkLThkNTRhZTUxY2NjYyIsImFpZCI6ImQyZWVkOWM0LWYyNzUtNDM4Yy1iMmU5LTMzZGM0Yjc4YWYxNSIsImJpVG9rZW4iOiJlMDZiMzExMi03MmE5LTBiMTUtMGNiMy0yYmQ1MGZkOTkyOTIiLCJzaXRlT3duZXJJZCI6ImJhODM5MTUzLTAzN2YtNDA2YS1iYWU2LTM2NzRmZmQ5OGFkYiJ9&isPrimaryLanguage=true&lang=fr&locale=fr&pageId=sz0gz&previousPathname=%2F&redirected=true&section-url=https%3A%2F%2Fmahedu974.wixsite.com%2Fmonsite%2Faccueil%2F&siteRevision=131&target=_top&viewMode=site&width=980');

    if (response.statusCode == 200) {
      RegExp regExp = new RegExp(
        r"window\.__INITIAL_STATE__ = ([\w\W]*?);[\n\t ]*window\.__CONFIG__",
        multiLine: true,
        caseSensitive: false,
      );

      var match = regExp.firstMatch(response.body);

      Map<String, dynamic> data = json.decode(match.group(1));
      List<WebArticle> articles = [];

      (data["posts"] as Map<String, dynamic>).forEach((key, value) {
        articles.add(WebArticle.fromJson(value));
      });

      return articles;
    } else {
      throw Exception('Failed to load post');
    }
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
