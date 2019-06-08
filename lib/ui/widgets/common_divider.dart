import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/utils/constants.dart';

class CommonDivider extends StatelessWidget {
  final double customHeight;

  CommonDivider({this.customHeight});

  @override
  Widget build(BuildContext context) {
    double height = customHeight ?? 8.0;

    return Divider(
      color: Constants.colorAccent,
      height: height,
    );
  }
}
