import 'package:mon_guide_musculation/models/forum.dart';
import 'package:mon_guide_musculation/utils/constants.dart';

class WixUtils {
  static String formatStaticWixImageUrl(file) {
    return WixUrls.mediaStaticPrefix + file;
  }

  static String formatStaticWixPostUrl(slug) {
    return WixUrls.baseUrl + "/monguidemusculation/post/" + slug;
  }
  
  static String formatMediaFileUrl(file) {
    return WixUrls.mediaStaticPrefix + file;
  }
  
  
  static String formatForumUrl(ForumThread forumThread) {
    print(WixUrls.forumPage + "/discussions-generales/${forumThread.slug}");
    return WixUrls.forumPage + "/discussions-generales/${forumThread.slug}";
  }
}
