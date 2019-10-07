import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/ui/widgets/top_round_background.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:mon_guide_musculation/utils/functions.dart';

class ContactScreen extends StatelessWidget {
  Widget _buildBigText(String text, {Color color = const Color(0xFF000000)}) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20.0,
        color: color,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildIcon(IconData icon, void onPressed()) {
    return FloatingActionButton(
      elevation: 0.0,
      highlightElevation: 0.0,
      onPressed: onPressed,
      backgroundColor: Constants.colorAccent,
      child: Icon(icon),
    );
  }

  Widget _buildLinkIcon(IconData icon, String url) {
    return _buildIcon(icon, () {
      if (url == null) {
      } else {
        openInBrowser(url);
      }
    });
  }

  Widget _buildCard(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildBigText(title),
              SizedBox(
                height: 10.0,
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          TopRoundBackground(
            widget: networkImage(Texts.ruisiBackgroundContactImageUrl),
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
                    _buildCard(
                      Texts.ruisiFullName,
                      Center(
                        child: Text(
                          Texts.ruisiAddress,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    _buildCard(
                      Texts.contactCoatching,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _buildLinkIcon(Icons.call, Contact.phoneNumber),
                          _buildLinkIcon(Icons.mail, Contact.mailAdress),
                          _buildLinkIcon(Icons.web, Contact.websiteUrl),
                        ],
                      ),
                    ),
                    _buildCard(
                      Texts.contactSocialNetworks,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _buildLinkIcon(MyIcons.instagram, Contact.instagramUrl),
                          _buildLinkIcon(MyIcons.facebook, Contact.facebookUrl),
                          _buildLinkIcon(MyIcons.youtube, Contact.youtubeUrl),
                        ],
                      ),
                    ),
                    _buildCard(
                      Texts.contactSupport,
                      FlatButton(
                        child: _buildBigText(Texts.makeADonation, color: Color(0xFFFFFFFF)),
                        color: Constants.colorAccent,
                        onPressed: () {
                          openInBrowser(Contact.donationUrl);
                        },
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
