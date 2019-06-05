import 'pages/home_page.dart';
import 'package:flutter/material.dart';



void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'NavigationDrawer Demo',
      theme: new ThemeData(
        primaryColor: const Color(0xFF345d7e),
      ),
      home: new HomePage(),
    );
  }
}