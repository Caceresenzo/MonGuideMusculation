import 'package:flutter/widgets.dart';
import 'package:mon_guide_musculation/models/forum.dart';
import 'package:mon_guide_musculation/utils/constants.dart';

class WixUtils {
  static String formatStaticWixImageUrl(file, {Size resize}) {
    String finalUrl = WixUrls.mediaStaticPrefix + file + (resize != null ? "/v1/fit/w_" + resize.width.toInt().toString() +  ",h_" + resize.height.toInt().toString() +  ",al_c,q_90/file.png" : "");
    
    print("URL: " + finalUrl);

    return finalUrl;
  }

  static String formatStaticWixPostUrl(slug) {
    return WixUrls.baseUrl + "/monguidemusculation/post/" + slug;
  }

  static String formatMediaFileUrl(file) {
    return WixUrls.mediaStaticPrefix + file;
  }

  static String formatForumUrl(ForumThread forumThread) {
    return WixUrls.forumPage + "/discussions-generales/${forumThread.slug}";
  }

  static String formatSportProgramUrlByToken(String token) {
    return WixUrls.backendGetSportProgramBase + token;
  }
}
