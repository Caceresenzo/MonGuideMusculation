import 'package:flutter/material.dart';

class Constants {
  static const Color colorAccent = const Color(0xFFEF6C00);
}

class Texts {
  static const String applicationName = "Mon Guide Musculation";
  static const String applicationVersion = "1.0.0";
  static const String applicationDeveloper = "par Enzo CACERES";

  static const String buttonClose = "FERMER";

  static const String tooltipAbout = "A Propos";

  static const String responseCountNone = "Aucune";
  static const String responseCountWord = "réponse";
  static const String responseCountWordMultiple = "réponses";

  static String responseCount(int count) {
    switch (count) {
      case 0:
        return responseCountNone + " " + responseCountWord;

      case 1:
        return count.toString() + " " + responseCountWord;

      default:
        return count.toString() + " " + responseCountWordMultiple;
    }
  }
}

class WixUrls {
  static const String baseUrl = "https://mahedu974.wixsite.com";
  static const String baseWixUrl = baseUrl + "/monguidemusculation";

  static const String mediaStaticPrefix = "https://static.wixstatic.com/media/";
  static const String articlesPage = "https://social-blog.wix.com/?compId=TPASection_jav3el7a&currency=EUR&dateNumberFormat=fr-fr&deviceType=desktop&height=1738&instance=S4Z6TuF8eiI1wsxFg4f1dJUlWHAFvkZQvyr-UD6--8I.eyJpbnN0YW5jZUlkIjoiYmU4YzE4OTctN2ZmZS00MWYxLWI1MGItZWEzYTIwMTczMGVhIiwiYXBwRGVmSWQiOiIxNGJjZGVkNy0wMDY2LTdjMzUtMTRkNy00NjZjYjNmMDkxMDMiLCJtZXRhU2l0ZUlkIjoiNWVlNzI5ODUtMGQ1Ny00YWU0LWI5YjgtYzFlZjJmY2VhMjc4Iiwic2lnbkRhdGUiOiIyMDE5LTA2LTA0VDE5OjU2OjMxLjI2OVoiLCJ1aWQiOm51bGwsImlwQW5kUG9ydCI6Ijg4LjEyNS4yMTQuNDMvNTIwMTQiLCJ2ZW5kb3JQcm9kdWN0SWQiOm51bGwsImRlbW9Nb2RlIjpmYWxzZSwib3JpZ2luSW5zdGFuY2VJZCI6IjhkZjRkODMzLTUxNWQtNDAxMy05ZmNkLThkNTRhZTUxY2NjYyIsImFpZCI6ImQyZWVkOWM0LWYyNzUtNDM4Yy1iMmU5LTMzZGM0Yjc4YWYxNSIsImJpVG9rZW4iOiJlMDZiMzExMi03MmE5LTBiMTUtMGNiMy0yYmQ1MGZkOTkyOTIiLCJzaXRlT3duZXJJZCI6ImJhODM5MTUzLTAzN2YtNDA2YS1iYWU2LTM2NzRmZmQ5OGFkYiJ9&isPrimaryLanguage=true&lang=fr&locale=fr&pageId=sz0gz&previousPathname=%2F&redirected=true&section-url=https%3A%2F%2Fmahedu974.wixsite.com%2Fmonsite%2Faccueil%2F&siteRevision=131&target=_top&viewMode=site&width=980";
  static const String forumPage = baseWixUrl + "/forum/";
}

class WixData {
  static const String typeAtomicLink = "LINK";
  static const String typeAtomicDevider = "wix-draft-plugin-divider";
  static const String typeAtomicImage = "wix-draft-plugin-image";
  static const String typeAtomicVideo = "wix-draft-plugin-video";
}
