import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

CachedNetworkImage networkImage(String imageUrl) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    placeholder: Center(
      child: new CircularProgressIndicator(),
    ),
    errorWidget: new Icon(
      Icons.error,
      color: Constants.colorAccent,
    ),
    fit: BoxFit.fitWidth,
  );
}

void openInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
