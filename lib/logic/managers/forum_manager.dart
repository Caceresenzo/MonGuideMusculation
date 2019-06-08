import 'dart:convert';

import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/models/forum.dart';
import 'package:http/http.dart' as http;
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:mon_guide_musculation/utils/wix_utils.dart';

class ForumManager extends BaseManager {
  final RegExp forumJsonExtractionRegex = RegExp(
    r'<script type="text\/javascript\">[\n\t ]*var warmupData = ([\w\W]*?);[\n\t ]*<\/script>',
    multiLine: true,
    caseSensitive: false,
  );

  List<ForumThread> cachedThreads;
  Map<String, List<ForumThreadAnswer>> cachedAnswers;

  @override
  void initialize() {
    cachedThreads = new List();
    cachedAnswers = new Map();
  }

  Future<List<ForumThread>> fetchPost(bool acceptCache, {void onError(error)}) async {
    if (cachedThreads.isNotEmpty && acceptCache) {
      return cachedThreads;
    }

    return http
        .get(WixUrls.forumPage)
        .then((response) {
          return response.statusCode == 200 ? response.body : throw 'Error when getting data';
        })
        .then((body) {
          return forumJsonExtractionRegex.firstMatch(body).group(1);
        })
        .then((rawJson) => json.decode(rawJson))
        .then((data) {
          cachedThreads.clear();

          (data["tpaWidgetNativeInitData"]["TPASection_jrg787fr"]["wixCodeProps"]["state"]["posts"] as Map<String, dynamic>).forEach((key, value) {
            cachedThreads.add(ForumThread.fromJson(value));
          });

          return cachedThreads;
        });

    /*try {
      final response = await http.get(WixUrls.forumPage);

      if (response.statusCode == 200) {
        RegExp regExp = new RegExp(
          r'<script type="text\/javascript\">[\n\t ]*var warmupData = ([\w\W]*?);[\n\t ]*<\/script>',
          multiLine: true,
          caseSensitive: false,
        );

        var match = regExp.firstMatch(response.body);
        print(response.body.length);

        Map<String, dynamic> data = json.decode(match.group(1));
        cachedThreads.clear();

        (data["tpaWidgetNativeInitData"]["TPASection_jrg787fr"]["wixCodeProps"]["state"]["posts"] as Map<String, dynamic>).forEach((key, value) {
          cachedThreads.add(ForumThread.fromJson(value));
        });

        return cachedThreads;
      }

      throw Exception('Failed to load post');
    } catch (error) {
      throw(error);
    } */
  }

  List<ForumThreadAnswer> _makeParentTree(List<ForumThreadAnswer> answers) {
    List<ForumThreadAnswer> parents = new List();
    List<ForumThreadAnswer> children = new List();

    answers.forEach((answer) {
      List target = parents;

      if (answer.parentId != null) {
        target = children;
      }

      target.add(answer);
    });

    children.forEach((child) {
      parents.forEach((parent) {
        if (child.parentId == parent.id) {
          child.parent = parent;
          parent.children.add(child);
        }
      });
    });

    return parents;
  }

  Future<List<ForumThreadAnswer>> fetchPostAnswer(ForumThread forumThread, bool acceptCache) async {
    final String threadId = forumThread.id;

    if (acceptCache) {
      List<ForumThreadAnswer> anwsers = cachedAnswers[threadId];

      if (anwsers != null && anwsers.isNotEmpty) {
        return anwsers;
      }
    }

    return http
        .get(WixUtils.formatForumUrl(forumThread))
        .then((response) {
          return response.statusCode == 200 ? response.body : throw 'Error when getting data';
        })
        .then((body) {
          return forumJsonExtractionRegex.firstMatch(body).group(1);
        })
        .then((rawJson) => json.decode(rawJson))
        .then((data) {
          List<ForumThreadAnswer> anwsers = new List();

          (data["tpaWidgetNativeInitData"]["TPASection_jrg787fr"]["wixCodeProps"]["state"]["comments"][threadId] as List<dynamic>).forEach((json) {
            anwsers.add(ForumThreadAnswer.fromJson(forumThread, json));
          });

          return anwsers;
        })
        .then((anwsers) => cachedAnswers[threadId] = _makeParentTree(anwsers));
  }
}
