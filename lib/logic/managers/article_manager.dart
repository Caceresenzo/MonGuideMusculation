import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/models/article.dart';
import 'package:http/http.dart' as http;
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
          print(body);
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
}
