import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/main.dart';
import 'package:mon_guide_musculation/ui/dialogs/about_dialog.dart';
import 'package:mon_guide_musculation/ui/pages/page_articles.dart';
import 'package:mon_guide_musculation/ui/pages/page_bodybuilding.dart';
import 'package:mon_guide_musculation/ui/pages/page_contact.dart';
import 'package:mon_guide_musculation/ui/pages/page_forum.dart';
import 'package:mon_guide_musculation/ui/pages/page_sportprogram.dart';
import 'package:mon_guide_musculation/ui/tests/test_charts.dart';
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

class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();

    Managers.finish();
  }

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

      /*case 5:
        return ChartsText();*/
    }

    throw Exception("Illegal State -> Position out of range.");
  }

  @override
  Widget build(BuildContext context) {
    MyApp.staticContext = context;

    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        key: HomePage.staticScaffoldStateKey,
        appBar: AppBar(
          elevation: 0.0,
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
              icon: Icon(Icons.format_list_bulleted),
              title: Text(Texts.navigationSportProgram),
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
            /*BottomNavigationBarItem(
              icon: Icon(Icons.mail),
              title: Text(Texts.navigationContact),
            ),*/
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Constants.colorAccent,
          showSelectedLabels: true,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Future<bool> _exitApp(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) {
            return new AlertDialog(
              title: new Text('Do you want to exit this application?'),
              content: new Text('We hate to see you leave...'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No'),
                ),
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: new Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
