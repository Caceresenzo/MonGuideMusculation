import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<String> _loadData() async {
  return await rootBundle.loadString('load_json/data.json');
}

Future loadData() async {
  String jsonString = await _loadData();
  final Json = json.decode(jsonString);

  if (Json == Null) {
    print("No json file was found");
  } else {
    print("Json file was found");
    var NumberOfAccounts = Json.length;
    print(NumberOfAccounts);
  }
}

class OverviewFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    loadData();
    return Scaffold();
  }
}

class MyCard extends StatelessWidget {
  MyCard({this.title, this.image});
  final Widget title;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return new Container(
        //adding bottom padding on card
        padding: new EdgeInsets.only(bottom: 20.0),
        child: new Card(
            child: new Container(
                //adding padding inside card
                padding: new EdgeInsets.all(15.0),
                child:
                    new Column(children: <Widget>[this.title, this.image]))));
  }
}
