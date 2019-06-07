import 'package:mon_guide_musculation/fragments/articles/articles.dart';
import 'package:mon_guide_musculation/fragments/contact/contact.dart';
import 'package:mon_guide_musculation/fragments/forum/forum.dart';
import 'package:mon_guide_musculation/ui/dialogs/about_dialog.dart';
import 'package:mon_guide_musculation/ui/pages/page_forum.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 2;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    null,
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _getDrawerItemWidget(int position) {
    switch (position) {
      case 2:
        return new ArticlesListFragment();

      case 3:
        return new ForumScreen();

      case 4:
        return new ContactWidget();

      default:
        return _widgetOptions.elementAt(_selectedIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Texts.applicationName),
        backgroundColor: Constants.colorAccent,
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.info_outline),
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
            title: Text('Magasin'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mouse),
            title: Text('Muscu'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed),
            title: Text('Articles'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('Forum'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            title: Text('Contact'),
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
