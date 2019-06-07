import 'package:mon_guide_musculation/logic/managers/article_manager.dart';
import 'package:mon_guide_musculation/logic/managers/forum_manager.dart';

abstract class BaseManager {

  void initialize() {
    ;
  }
  
}

class Managers {

  static List<BaseManager> managers = [];

  static ArticleManager articleManager;
  static ForumManager forumManager;

  static initialize() {
    managers.add(articleManager = new ArticleManager());
    managers.add(forumManager = new ForumManager());

    managers.forEach((manager){
      manager.initialize();
    });
  }

}
