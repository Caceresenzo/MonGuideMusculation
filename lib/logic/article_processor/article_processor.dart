import 'package:flutter/cupertino.dart';
import 'package:mon_guide_musculation/models/article.dart';

class ArticleProcessor {
  WebArticle article;

  ArticleProcessor({this.article});

  List<List<ArticleContentItem>> organize(BuildContext context) {
    List<List<ArticleContentItem>> items = [];

    List<ArticleContentItem> currentItems = [];
    ArticleContentItem lastTitle;

    article.content.items.forEach((item) {
      if (item.isTitle()) {
        if (lastTitle != null) {
          items.add(currentItems);
        }

        lastTitle = item;
        currentItems = [item];
      } else {
        currentItems.add(item);
      }
    });
    items.add(currentItems);

    return items;
  }
}
