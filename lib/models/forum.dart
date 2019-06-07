import 'package:flutter/cupertino.dart';
import 'package:mon_guide_musculation/logic/wix_block_processor/wix_block_extractor.dart';
import 'package:mon_guide_musculation/logic/wix_block_processor/wix_block_processor.dart';
import 'package:mon_guide_musculation/models/user.dart';
import 'package:mon_guide_musculation/models/wix.dart';

class ForumThread {
  String title;
  User owner;
  WixBasicStatistics stats;
  ForumThreadContent content;

  ForumThread({@required this.title, @required this.owner, this.stats, @required this.content});

  factory ForumThread.fromJson(Map<String, dynamic> data) {
    return new ForumThread(
      title: data["title"],
      owner: User.fromJson(data["owner"]),
      stats: WixBasicStatistics.fromJson(data),
      content: ForumThreadContent.fromJson(null, data),
    );
  }
}

class ForumThreadContent {
  ForumThread parentArticle;
  List<WixBlockItem> items;
  int totalComments;

  ForumThreadContent({@required this.parentArticle, this.items, this.totalComments});

  factory ForumThreadContent.fromJson(ForumThread parent, Map<String, dynamic> data) {
    return new ForumThreadContent(
      parentArticle: parent,
      items: WixBlockExtractor.extractFromJson(data["content"]),
      totalComments: data["totalComments"],
    );
  }

  WixBlockProcessor autoProcessor() {
    return WixBlockProcessor(
      blocks: items,
    );
  }
}