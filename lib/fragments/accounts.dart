import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/material.dart';
import 'addAccount.dart';

class AccountsFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> litems = ["1", "2", "Third", "4"];

    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 100.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text("Manage your accounts",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        )),
                    background: Image.network(
                      "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                      fit: BoxFit.cover,
                    )),
              ),
            ];
          },
          body: new ListView.builder(
              itemCount: litems.length,
              itemBuilder: (BuildContext ctxt, int index) {
                var item = litems[index];

                return new Card(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new MyCard(title: new Text(item)),
                    ],
                  ),
                );
              })),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  List data;
  @override
  Widget build(BuildContext context) {
    //Scaffold provide functionality of appbar, body of app etc
    return new Scaffold(
        body: new Container(
            //adding padding around card
            padding: new EdgeInsets.all(20.0),
            child: new Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
              RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('Go to SubPage'),
                onPressed: () {
                  navigateToSubPage(context);
                },
              )
            ])));
  }
}

Future navigateToSubPage(context) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AddPage()));
}

class MyCard extends StatelessWidget {
  //adding constructor
  MyCard({this.title});

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return new Container(
        //adding bottom padding on card
        padding: new EdgeInsets.only(bottom: 20.0),
        child: new Card(
            child: new Container(
                //adding padding inside card
                padding: new EdgeInsets.all(15.0),
                child: new Column(children: <Widget>[this.title]))));
  }
}
