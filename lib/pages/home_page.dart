import 'package:mon_guide_musculation/main.dart';
import 'package:mon_guide_musculation/ui/dialogs/about_dialog.dart';
import 'package:mon_guide_musculation/ui/pages/page_articles.dart';
import 'package:mon_guide_musculation/ui/pages/page_bodybuilding.dart';
import 'package:mon_guide_musculation/ui/pages/page_contact.dart';
import 'package:mon_guide_musculation/ui/pages/page_forum.dart';
import 'package:mon_guide_musculation/ui/pages/page_sportprogram.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static final GlobalKey<ScaffoldState> staticScaffoldStateKey = new GlobalKey();

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }

  static void hideSnackBar() {
    if (HomePage.staticScaffoldStateKey.currentState != null) {
      HomePage.staticScaffoldStateKey.currentState.hideCurrentSnackBar();
    }
  }

  static void showSnackBar(SnackBar snackBar, {bool hidePrevious = true}) {
    if (hidePrevious) {
      hideSnackBar();
    }

    if (HomePage.staticScaffoldStateKey.currentState != null) {
      HomePage.staticScaffoldStateKey.currentState.showSnackBar(snackBar);
    }
  }
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getDrawerItemWidget(int position) {
    HomePage.hideSnackBar();

    switch (position) {
      case 0:
        return new SportProgramScreen();

      case 1:
        return new BodyBuildingScreen();

      case 2:
        return new ArticleScreen();

      case 3:
        return new ForumScreen();

      case 4:
        return new ContactScreen();
    }

    throw Exception("Illegal State -> Position out of range.");
  }

  @override
  Widget build(BuildContext context) {
    MyApp.staticContext = context;

    return Scaffold(
      key: HomePage.staticScaffoldStateKey,
      appBar: AppBar(
        title: Text(Texts.applicationName),
        backgroundColor: Constants.colorAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              MyIcons.emo_beer,
              size: 16.0,
            ),
            onPressed: () {
              MyAboutDialog.show(context);
            },
            tooltip: Texts.tooltipAbout,
          )
        ],
      ),
      body: Center(child: _getDrawerItemWidget(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            title: Text(Texts.navigationShop),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("icons/navigation/muscle.png")),
            title: Text(Texts.navigationBodyBuilding),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed),
            title: Text(Texts.navigationArticles),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text(Texts.navigationForum),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            title: Text(Texts.navigationContact),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Constants.colorAccent,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
