import 'dart:convert';

import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/models/forum.dart';
import 'package:http/http.dart' as http;
import 'package:mon_guide_musculation/utils/constants.dart';

class ForumManager extends BaseManager {
  List<ForumThread> cachedThreads;

  @override
  void initialize() {
    cachedThreads = [];
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
          return RegExp(
            r'<script type="text\/javascript\">[\n\t ]*var warmupData = ([\w\W]*?);[\n\t ]*<\/script>',
            multiLine: true,
            caseSensitive: false,
          ).firstMatch(body).group(1);
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
}
