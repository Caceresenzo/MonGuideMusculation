import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/logic/wix_block_processor/wix_block_extractor.dart';
import 'package:mon_guide_musculation/models/user.dart';
import 'package:mon_guide_musculation/models/wix.dart';
import 'package:mon_guide_musculation/utils/wix_utils.dart';

class WebArticle {
  String slug;
  User author;
  String releaseDate;
  String readingTimeEstimation;
  String title;
  String seoDescription;
  WixBasicStatistics stats;
  String coverImageSource;
  ArticleContent content;

  WebArticle({
    this.slug,
    this.author,
    this.releaseDate,
    this.readingTimeEstimation,
    this.title,
    this.seoDescription,
    this.stats,
    this.coverImageSource,
    this.content,
  });

  factory WebArticle.fromJson(Map<String, dynamic> json) {
    /* A bit ugly, but that were ugly at the beginning... */

    WebArticle webArticle = WebArticle(
      slug: json['slug'],
      author: User.fromJson(json['owner']),
      title: json['title'].replaceAll(new RegExp(r'\n'), ''),
      seoDescription: json['seoDescription'],
      stats: WixBasicStatistics.fromJson(json),
      coverImageSource: json['coverImage']["src"]["file_name"],
    );

    webArticle.content = ArticleContent.fromJson(webArticle, json);

    return webArticle;
  }

  String toRemoteUrl() {
    return WixUtils.formatStaticWixPostUrl(slug);
  }
}

class ArticleContent {
  WebArticle parentArticle;
  List<WixBlockItem> items;

  ArticleContent({
    @required this.parentArticle,
    this.items,
  });

  Future<List<WixBlockItem>> fetch({bool acceptCache = true}) async {
    return Managers.articleManager.fetchArticleContent(parentArticle, acceptCache);
  }

  factory ArticleContent.fromJson(WebArticle parent, Map<String, dynamic> data) {
    dynamic content = data["content"];

    return ArticleContent(
      parentArticle: parent,
      items: content == null ? null : WixBlockExtractor.extractFromJson(data["content"]),
    );
  }
}
