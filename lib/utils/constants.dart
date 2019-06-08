import 'package:flutter/material.dart';

class Constants {
  static const Color colorAccent = const Color(0xFFEF6C00);
  static const Color colorCodeblock = const Color(0xFFF2F2F2);
}

class Texts {
  static const String applicationName = "Mon Guide Musculation";
  static const String applicationVersion = "1.0.0";
  static const String applicationDeveloper = "par Enzo CACERES";
  
  static const String contactMe = "ME CONTACTER";
  static const String contactSocialNetworks = "RÉSEAUX SOCIAUX";
  static const String ruisiFullName = "Mahé RUISI";
  static const String ruisiAddress = "4 North Joy Ridge St.\nRoswell, GA 30075\nFrance";
  
  static const String pageNoContent = "Aucun contenu.";
  static const String pageNoAnswer = "Aucune réponse.";
  static const String pageFailedToLoad = "Chargement échoué.";

  static const String buttonClose = "FERMER";

  static const String tooltipAbout = "A Propos";
  static const String tooltipOpenInBrowser = "Ouvrir dans le navigateur";

  static const String answerCountNone = "Aucune";
  static const String answerCountWord = "réponse";
  static const String answerCountWordMultiple = "réponses";

  static String answerCount(int count) {
    switch (count) {
      case 0:
        return answerCountNone + " " + answerCountWord;

      case 1:
        return count.toString() + " " + answerCountWord;

      default:
        return count.toString() + " " + answerCountWordMultiple;
    }
  }
}

class Contact {
  static const String phoneNumber = "tel://+33668770723";
  static const String mailAdress = "mailto:mahedu974@gmail.com";
  static const String websiteUrl = "https://www.monguidemusculation.com/";

  static const String instagramUrl = "https://www.instagram.com/mamaheheruiruisisi/";
  static const String facebookUrl = "https://www.facebook.com/Monguidemusculation/";
  static const String youtubeUrl = null;
}

class MyIcons {
  MyIcons._();

  static const _kFontFam = 'MyIcons';

  /* Font Awesome */
  static const IconData facebook = const IconData(0xf09a, fontFamily: _kFontFam);
  static const IconData youtube = const IconData(0xf167, fontFamily: _kFontFam);
  static const IconData instagram = const IconData(0xf16d, fontFamily: _kFontFam);

  /* Fontelico */
  static const IconData emo_happy = const IconData(0xe800, fontFamily: _kFontFam);
  static const IconData emo_wink = const IconData(0xe801, fontFamily: _kFontFam);
  static const IconData emo_unhappy = const IconData(0xe802, fontFamily: _kFontFam);
  static const IconData emo_sleep = const IconData(0xe803, fontFamily: _kFontFam);
  static const IconData emo_thumbsup = const IconData(0xe804, fontFamily: _kFontFam);
  static const IconData emo_devil = const IconData(0xe805, fontFamily: _kFontFam);
  static const IconData emo_surprised = const IconData(0xe806, fontFamily: _kFontFam);
  static const IconData emo_tongue = const IconData(0xe807, fontFamily: _kFontFam);
  static const IconData emo_coffee = const IconData(0xe808, fontFamily: _kFontFam);
  static const IconData emo_sunglasses = const IconData(0xe809, fontFamily: _kFontFam);
  static const IconData emo_displeased = const IconData(0xe80a, fontFamily: _kFontFam);
  static const IconData emo_beer = const IconData(0xe80b, fontFamily: _kFontFam);
  static const IconData emo_grin = const IconData(0xe80c, fontFamily: _kFontFam);
  static const IconData emo_angry = const IconData(0xe80d, fontFamily: _kFontFam);
  static const IconData emo_saint = const IconData(0xe80e, fontFamily: _kFontFam);
  static const IconData emo_cry = const IconData(0xe80f, fontFamily: _kFontFam);
  static const IconData emo_shoot = const IconData(0xe810, fontFamily: _kFontFam);
  static const IconData emo_squint = const IconData(0xe811, fontFamily: _kFontFam);
  static const IconData emo_laugh = const IconData(0xe812, fontFamily: _kFontFam);
  static const IconData emo_wink2 = const IconData(0xe813, fontFamily: _kFontFam);
  static const IconData crown = const IconData(0xe844, fontFamily: _kFontFam);
}


class WixUrls {
  static const String baseUrl = "https://www.monguidemusculation.com";

  static const String mediaStaticPrefix = "https://static.wixstatic.com/media/";
  static const String articlesPage = "https://social-blog.wix.com/?compId=TPASection_jav3el7a&currency=EUR&dateNumberFormat=fr-fr&deviceType=desktop&height=1738&instance=S4Z6TuF8eiI1wsxFg4f1dJUlWHAFvkZQvyr-UD6--8I.eyJpbnN0YW5jZUlkIjoiYmU4YzE4OTctN2ZmZS00MWYxLWI1MGItZWEzYTIwMTczMGVhIiwiYXBwRGVmSWQiOiIxNGJjZGVkNy0wMDY2LTdjMzUtMTRkNy00NjZjYjNmMDkxMDMiLCJtZXRhU2l0ZUlkIjoiNWVlNzI5ODUtMGQ1Ny00YWU0LWI5YjgtYzFlZjJmY2VhMjc4Iiwic2lnbkRhdGUiOiIyMDE5LTA2LTA0VDE5OjU2OjMxLjI2OVoiLCJ1aWQiOm51bGwsImlwQW5kUG9ydCI6Ijg4LjEyNS4yMTQuNDMvNTIwMTQiLCJ2ZW5kb3JQcm9kdWN0SWQiOm51bGwsImRlbW9Nb2RlIjpmYWxzZSwib3JpZ2luSW5zdGFuY2VJZCI6IjhkZjRkODMzLTUxNWQtNDAxMy05ZmNkLThkNTRhZTUxY2NjYyIsImFpZCI6ImQyZWVkOWM0LWYyNzUtNDM4Yy1iMmU5LTMzZGM0Yjc4YWYxNSIsImJpVG9rZW4iOiJlMDZiMzExMi03MmE5LTBiMTUtMGNiMy0yYmQ1MGZkOTkyOTIiLCJzaXRlT3duZXJJZCI6ImJhODM5MTUzLTAzN2YtNDA2YS1iYWU2LTM2NzRmZmQ5OGFkYiJ9&isPrimaryLanguage=true&lang=fr&locale=fr&pageId=sz0gz&previousPathname=%2F&redirected=true&section-url=https%3A%2F%2Fmahedu974.wixsite.com%2Fmonsite%2Faccueil%2F&siteRevision=131&target=_top&viewMode=site&width=980";
  static const String forumPage = baseUrl + "/forum/";
}

class WixData {
  static const String typeAtomicLink = "LINK";
  static const String typeAtomicDevider = "wix-draft-plugin-divider";
  static const String typeAtomicImage = "wix-draft-plugin-image";
  static const String typeAtomicVideo = "wix-draft-plugin-video";
}
