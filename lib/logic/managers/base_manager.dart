import 'package:mon_guide_musculation/logic/managers/article_manager.dart';
import 'package:mon_guide_musculation/logic/managers/bodybuilding_manager.dart';
import 'package:mon_guide_musculation/logic/managers/forum_manager.dart';
import 'package:mon_guide_musculation/logic/managers/sportprogram_manager.dart';

import 'link_manager.dart';

abstract class BaseManager {
  void initialize() {}
  void finish() {}
}

class Managers {
  static List<BaseManager> managers = [];

  static ArticleManager articleManager;
  static ForumManager forumManager;
  static BodyBuildingManager bodyBuildingManager;
  static SportProgramManager sportProgramManager;
  static LinkManager linkManager;

  static initialize() {
    print("Initializing...");

    managers.add(articleManager = new ArticleManager());
    managers.add(forumManager = new ForumManager());
    managers.add(bodyBuildingManager = new BodyBuildingManager());
    managers.add(sportProgramManager = new SportProgramManager());
    managers.add(linkManager = new LinkManager());

    managers.forEach((manager) {
      print("Initializing manager \"${manager.runtimeType.toString()}\"...");
      
      manager.initialize();
    });
  }

  static void finish() {
    managers.forEach((manager) {
      print("Finshing manager \"${manager.runtimeType.toString()}\"...");

      manager.finish();
    });
  }
}
