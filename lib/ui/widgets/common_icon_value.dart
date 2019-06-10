import 'package:flutter/material.dart';

class IconValue extends StatelessWidget {
  final IconData icon;
  final dynamic value;

  const IconValue(
    this.icon,
    this.value, {
    Key key,
  })  : assert(icon != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 2.0,
      ),
      child: Row(
        children: <Widget>[
          Icon(icon),
          Container(
            width: 8,
          ),
          Text(value != null ? value.toString() : "null"),
        ],
      ),
    );
  }
}
