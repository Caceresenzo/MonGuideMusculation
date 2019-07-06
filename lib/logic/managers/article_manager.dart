import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/logic/wix_block_processor/wix_block_extractor.dart';
import 'package:mon_guide_musculation/models/article.dart';
import 'package:http/http.dart' as http;
import 'package:mon_guide_musculation/models/wix.dart';
import 'dart:convert';

import 'package:mon_guide_musculation/utils/constants.dart';

class ArticleManager extends BaseManager {
  final RegExp articleJsonExtractionRegex = RegExp(
    r'window\.__INITIAL_STATE__ = ([\w\W]*?);[\n\t ]*window\.__CONFIG__',
    multiLine: true,
    caseSensitive: false,
  );

  List<WebArticle> cachedArticles;

  @override
  void initialize() {
    cachedArticles = [];
  }

  Future<List<WebArticle>> fetchPost(bool acceptCache) async {
    if (cachedArticles.isNotEmpty && acceptCache) {
      return cachedArticles;
    }

    cachedArticles.clear();

    return http
        .get(WixUrls.articlesPage)
        .then((response) {
          return response.statusCode == 200 ? response.body : throw 'Error when getting data';
        })
        .then((body) {
          return articleJsonExtractionRegex.firstMatch(body).group(1);
        })
        .then((rawJson) => json.decode(rawJson))
        .then((data) {
          (data["posts"] as Map<String, dynamic>).forEach((key, value) {
            cachedArticles.add(WebArticle.fromJson(value));
          });

          return cachedArticles;
        });
  }

  Future<List<WixBlockItem>> fetchArticleContent(WebArticle parentArticle, bool acceptCache) async {
    if (acceptCache && parentArticle.content.items != null) {
      return parentArticle.content.items;
    }

    return http
        .get(WixUrls.formatArticleContentPage(parentArticle.slug))
        .then((response) {
          return response.statusCode == 200 ? response.body : throw 'Error when getting data';
        })
        .then((body) {
          return articleJsonExtractionRegex.firstMatch(body).group(1);
        })
        .then((rawJson) => json.decode(rawJson))
        .then((data) {
          Map<String, dynamic> verifiedData;

          (data["posts"] as Map<String, dynamic>).forEach((key, value) {
            if (verifiedData != null) {
              return;
            }

            if (value["slug"] == parentArticle.slug) {
              verifiedData = value;
            }
          });

          return verifiedData;
        })
        .then((verifiedData) {
          return parentArticle.content.items = WixBlockExtractor.extractFromJson(verifiedData["content"]);
        });
  }
}
