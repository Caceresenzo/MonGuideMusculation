import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/ui/widgets/top_round_background.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:mon_guide_musculation/utils/functions.dart';

class ContactWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          TopRoundBackground(
            widget: networkImage("https://static.wixstatic.com/media/1bf8c6_93938e2c2d1a4f6aab8bccf32a262750~mv2.jpeg"),
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        elevation: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                "Mahé RUISI".toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text("4 North Joy Ridge St.\nRoswell, GA 30075\nFrance"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              /*Container(
                                width: double.infinity,
                                child: RaisedButton.icon(
                                  onPressed: () {},
                                  color: Constants.colorAccent,
                                  label: Text(
                                    "Passer un appel",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  icon: Icon(
                                    Icons.call,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                width: double.infinity,
                                child: RaisedButton.icon(
                                  onPressed: () {},
                                  color: Constants.colorAccent,
                                  label: Text(
                                    "Envoyer un mail",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  icon: Icon(
                                    Icons.mail,
                                    color: Colors.white,
                                  ),
                                ),
                              ), */
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  FloatingActionButton(
                                    onPressed: () {},
                                    backgroundColor: Constants.colorAccent,
                                    child: Icon(
                                      Icons.call,
                                    ),
                                  ),
                                  FloatingActionButton(
                                    onPressed: () {},
                                    backgroundColor: Constants.colorAccent,
                                    child: Icon(Icons.mail),
                                  ),
                                  FloatingActionButton(
                                    onPressed: () {},
                                    backgroundColor: Constants.colorAccent,
                                    child: Icon(Icons.web),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    /*Scaffold(
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: ListView(
          children: <Widget>[
            TopRoundBackground(
              widget: networkImage("https://static.wixstatic.com/media/1bf8c6_93938e2c2d1a4f6aab8bccf32a262750~mv2.jpeg"),
            ),
          ],
        ),
      ),
    ); */
  }
}
