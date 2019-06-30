import 'dart:io';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:path_provider/path_provider.dart';
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

Future<String> getLocalPath() async {
  return (await getApplicationDocumentsDirectory()).path;
}

Future<File> getLocalFile(name) async {
  String path = await getLocalPath();

  return File('$path/$name');
}

dynamic getWithProcessing(List<dynamic> list, bool matcher(dynamic other)) {
  if (list != null) {
    for (dynamic item in list) {
      if (matcher(item)) {
        return item;
      }
    }
  }

  return null;
}

String toMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}
