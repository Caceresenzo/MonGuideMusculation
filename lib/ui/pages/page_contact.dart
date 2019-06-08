import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/ui/widgets/top_round_background.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:mon_guide_musculation/utils/functions.dart';

class ContactScreen extends StatelessWidget {
  Widget _buildBigText(String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
      textAlign: TextAlign.center,
    );
  }

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
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              _buildBigText(Texts.ruisiFullName),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(Texts.ruisiAddress),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              _buildBigText(Texts.contactMe),
                              SizedBox(
                                height: 10.0,
                              ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              _buildBigText(Texts.contactSocialNetworks),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  FloatingActionButton(
                                    onPressed: () {},
                                    backgroundColor: Constants.colorAccent,
                                    child: Icon(
                                      MyIcons.instagram,
                                    ),
                                  ),
                                  FloatingActionButton(
                                    onPressed: () {},
                                    backgroundColor: Constants.colorAccent,
                                    child: Icon(
                                      MyIcons.facebook,
                                    ),
                                  ),
                                  FloatingActionButton(
                                    onPressed: () {},
                                    backgroundColor: Constants.colorAccent,
                                    child: Icon(
                                      MyIcons.youtube,
                                    ),
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
  }
}
