import 'package:flutter/material.dart';

class Constants {
  static const String baseUrl = "https://mahedu974.wixsite.com";
  static const Color colorAccent = const Color(0xFFEF6C00);

  static String formatStaticWixImageUrl(file) {
    return "https://static.wixstatic.com/media/" + file;
  }

  static String formatStaticWixPostUrl(slug) {
    return baseUrl + "/monguidemusculation/post/" + slug;
  }
}

class Texts {
  static const String applicationName = "Mon Guide Musculation";
  static const String applicationVersion = "1.0.0";
  static const String applicationDeveloper = "par Enzo CACERES";
  
  static const String buttonClose = "FERMER";

  static const String tooltipAbout = "A Propos";
}

class WixData {
  static const String typeAtomicLink = "LINK";
  static const String typeAtomicDevider = "wix-draft-plugin-divider";
  static const String typeAtomicImage = "wix-draft-plugin-image";
  static const String typeAtomicVideo = "wix-draft-plugin-video";

}
