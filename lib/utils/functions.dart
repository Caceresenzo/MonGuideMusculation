import 'dart:io';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart';
import 'package:mon_guide_musculation/main.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

CachedNetworkImage networkImage(String imageUrl) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    placeholder: (context, url) {
      return Center(
        child: new CircularProgressIndicator(),
      );
    },
    errorWidget: (context, url, error) {
      print("Failed to receive image: ${error.toString()}");
      return new Icon(
        Icons.error,
        color: Constants.colorAccent,
      );
    },
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

String formatDuration(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

Widget buildBasicDialogTitle(String text) {
  return new Text(
    text,
    style: const TextStyle(
      color: Constants.colorAccent,
    ),
    textAlign: TextAlign.center,
  );
}

Future navigatorPush(BuildContext context, Widget widget) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));
}

num safeNumber(num number) {
  int intValue = number.toInt();

  if (intValue == number) {
    return intValue;
  }

  return number;
}
