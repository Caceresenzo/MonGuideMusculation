import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/models/article.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mon_guide_musculation/utils/constants.dart';

class ArticleManager extends BaseManager {
  List<WebArticle> cachedArticles;

  @override
  void initialize() {
    cachedArticles = [];
  }

  Future<List<WebArticle>> fetchPost(bool acceptCache) async {
    if (cachedArticles.isNotEmpty && acceptCache) {
      return cachedArticles;
    }

    final response = await http.get(WixUrls.articlesPage);

    if (response.statusCode == 200) {
      RegExp regExp = new RegExp(
        r"window\.__INITIAL_STATE__ = ([\w\W]*?);[\n\t ]*window\.__CONFIG__",
        multiLine: true,
        caseSensitive: false,
      );

      var match = regExp.firstMatch(response.body);

      Map<String, dynamic> data = json.decode(match.group(1));
      cachedArticles.clear();

      (data["posts"] as Map<String, dynamic>).forEach((key, value) {
        cachedArticles.add(WebArticle.fromJson(value));
      });

      return cachedArticles;
    } else {
      throw Exception('Failed to load post');
    }
  }
}
