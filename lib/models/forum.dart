import 'package:flutter/cupertino.dart';
import 'package:mon_guide_musculation/logic/wix_block_processor/wix_block_extractor.dart';
import 'package:mon_guide_musculation/logic/wix_block_processor/wix_block_processor.dart';
import 'package:mon_guide_musculation/models/user.dart';
import 'package:mon_guide_musculation/models/wix.dart';

class ForumThread {
  String id;
  String slug;
  String title;
  User owner;
  WixBasicStatistics stats;
  ForumThreadContent content;

  ForumThread({
    @required this.id,
    @required this.slug,
    @required this.title,
    @required this.owner,
    this.stats,
    @required this.content,
  });

  factory ForumThread.fromJson(Map<String, dynamic> data) {
    return new ForumThread(
      id: data["_id"],
      slug: data["slug"],
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

  ForumThreadContent({
    @required this.parentArticle,
    this.items,
    this.totalComments,
  });

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

class ForumThreadAnswer {
  ForumThread parentArticle;
  String id;
  String parentId;
  ForumThreadAnswer parent;
  List<ForumThreadAnswer> children = List();
  User owner;
  List<WixBlockItem> items;
  int likeCount;

  ForumThreadAnswer({
    @required this.id,
    @required this.parentArticle,
    this.parentId,
    this.owner,
    this.items,
    this.likeCount,
  });

  factory ForumThreadAnswer.fromJson(ForumThread parent, Map<String, dynamic> data) {
    return new ForumThreadAnswer(
      parentArticle: parent,
      id: data["_id"],
      parentId: data["parentId"],
      items: WixBlockExtractor.extractFromJson(data["content"]),
      owner: User.fromJson(data["owner"]),
      likeCount: data["likeCount"],
    );
  }

  WixBlockProcessor autoProcessor() {
    return WixBlockProcessor(
      blocks: items,
    );
  }
}
