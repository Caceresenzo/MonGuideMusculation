import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/models/article.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

    final response = await http.get('https://social-blog.wix.com/?compId=TPASection_jav3el7a&currency=EUR&dateNumberFormat=fr-fr&deviceType=desktop&height=1738&instance=S4Z6TuF8eiI1wsxFg4f1dJUlWHAFvkZQvyr-UD6--8I.eyJpbnN0YW5jZUlkIjoiYmU4YzE4OTctN2ZmZS00MWYxLWI1MGItZWEzYTIwMTczMGVhIiwiYXBwRGVmSWQiOiIxNGJjZGVkNy0wMDY2LTdjMzUtMTRkNy00NjZjYjNmMDkxMDMiLCJtZXRhU2l0ZUlkIjoiNWVlNzI5ODUtMGQ1Ny00YWU0LWI5YjgtYzFlZjJmY2VhMjc4Iiwic2lnbkRhdGUiOiIyMDE5LTA2LTA0VDE5OjU2OjMxLjI2OVoiLCJ1aWQiOm51bGwsImlwQW5kUG9ydCI6Ijg4LjEyNS4yMTQuNDMvNTIwMTQiLCJ2ZW5kb3JQcm9kdWN0SWQiOm51bGwsImRlbW9Nb2RlIjpmYWxzZSwib3JpZ2luSW5zdGFuY2VJZCI6IjhkZjRkODMzLTUxNWQtNDAxMy05ZmNkLThkNTRhZTUxY2NjYyIsImFpZCI6ImQyZWVkOWM0LWYyNzUtNDM4Yy1iMmU5LTMzZGM0Yjc4YWYxNSIsImJpVG9rZW4iOiJlMDZiMzExMi03MmE5LTBiMTUtMGNiMy0yYmQ1MGZkOTkyOTIiLCJzaXRlT3duZXJJZCI6ImJhODM5MTUzLTAzN2YtNDA2YS1iYWU2LTM2NzRmZmQ5OGFkYiJ9&isPrimaryLanguage=true&lang=fr&locale=fr&pageId=sz0gz&previousPathname=%2F&redirected=true&section-url=https%3A%2F%2Fmahedu974.wixsite.com%2Fmonsite%2Faccueil%2F&siteRevision=131&target=_top&viewMode=site&width=980');

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
