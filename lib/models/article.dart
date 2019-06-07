import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/logic/wix_block_processor/wix_block_extractor.dart';
import 'package:mon_guide_musculation/models/wix.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:mon_guide_musculation/utils/wix_utils.dart';

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
    return WixUtils.formatStaticWixPostUrl(slug);
  }
}

class ArticleContent {
  WebArticle parentArticle;
  List<WixBlockItem> items;

  ArticleContent({@required this.parentArticle, this.items});

  factory ArticleContent.fromJson(WebArticle parent, Map<String, dynamic> data) {
    return ArticleContent(
      parentArticle: parent,
      items: WixBlockExtractor.extractFromJson(data["content"]),
    );
  }
}
