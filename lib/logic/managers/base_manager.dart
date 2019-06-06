import 'package:mon_guide_musculation/logic/managers/article_manager.dart';

abstract class BaseManager {

  void initialize() {
    ;
  }
  
}

class Managers {

  static List<BaseManager> managers = [];

  static ArticleManager articleManager;

  static initialize() {
    managers.add(articleManager = new ArticleManager());

    managers.forEach((manager){
      manager.initialize();
    });
  }

}
