import 'dart:io';

import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/utils/constants.dart';

import 'pages/home_page.dart';
import 'package:flutter/material.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  Managers.initialize();

  runApp(new MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)..maxConnectionsPerHost = 500;
  }
}

class MyApp extends StatelessWidget {
  static BuildContext staticContext;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: Texts.applicationName,
      theme: new ThemeData(
        accentColor: Constants.colorAccent,
        primaryColor: const Color(0xFF345d7e),
      ),
      home: new HomePage(),
    );
  }
}
