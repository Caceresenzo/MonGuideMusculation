import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/utils/constants.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoCard({
    Key key,
    this.icon,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              color: Constants.colorAccent,
              size: 64.0,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 24.0),
            )
          ],
        ),
      ),
    );
  }
}
