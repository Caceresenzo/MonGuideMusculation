import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/utils/constants.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final String subText;

  const InfoCard({
    Key key,
    this.icon,
    this.text,
    this.subText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
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
            ),
            subText != null
                ? Text(
                    subText,
                    style: TextStyle(fontSize: 12.0, color: Colors.greenAccent),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  static InfoCard templateNoContent() {
    return InfoCard(
      icon: MyIcons.emo_sunglasses,
      text: Texts.pageNoContent,
      subText: Texts.pageNoContentSub,
    );
  }

  static InfoCard templateNoAnswer() {
    return InfoCard(
      icon: MyIcons.emo_cry,
      text: Texts.pageNoAnswer,
      subText: Texts.pageNoAnswerSub,
    );
  }

  static InfoCard templateFailedToLoad() {
    return InfoCard(
      icon: MyIcons.emo_displeased,
      text: Texts.pageFailedToLoad,
      subText: Texts.pageFailedToLoadSub,
    );
  }

  static InfoCard templateEmpty() {
    return InfoCard(
      icon: MyIcons.emo_displeased,
      text: Texts.pageEmpty,
      subText: Texts.pageEmptySub,
    );
  }
}
