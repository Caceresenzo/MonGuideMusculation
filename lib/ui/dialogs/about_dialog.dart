import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/ui/widgets/common_divider.dart';
import 'package:mon_guide_musculation/utils/constants.dart';

class MyAboutDialog extends StatelessWidget {
  final String applicationName;
  final String applicationVersion;
  final Widget applicationIcon;
  final String smallText;
  final List<Widget> children;

  const MyAboutDialog({
    Key key,
    this.applicationName,
    this.applicationVersion,
    this.applicationIcon,
    this.smallText,
    this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String name = applicationName;
    final String version = applicationVersion;
    final Widget icon = applicationIcon;
    List<Widget> body = <Widget>[];

    if (icon != null) {
      body.add(IconTheme(data: const IconThemeData(size: 48.0), child: icon));
    }

    body.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ListBody(
          children: <Widget>[
            Text(
              name,
              style: Theme.of(context).textTheme.headline,
              textAlign: TextAlign.center,
            ),
            Text(
              version,
              style: Theme.of(context).textTheme.body1,
              textAlign: TextAlign.center,
            ),
            Container(height: 18.0),
            Text(
              smallText ?? '',
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
            Container(height: 5.0),
          ],
        ),
      ),
    );

    if (children != null) {
      body.add(CommonDivider());
      body.add(Container(height: 5.0));
      body.addAll(children);
    }

    return AlertDialog(
      content: SingleChildScrollView(
        child: ListBody(children: body),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(Texts.buttonClose),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return MyAboutDialog(
          applicationName: Texts.applicationName,
          applicationVersion: Texts.applicationVersion,
          applicationIcon: ImageIcon(
            AssetImage('icon/luncher.png'),
          ),
          smallText: Texts.applicationDeveloper,
          /*children: <Widget>[
            Text(
              "Developed By\nEnzo CACERES",
              textAlign: TextAlign.center,
            ),
          ], */
        );
      },
    );
  }
}
