import 'package:flutter/widgets.dart';
import 'package:mon_guide_musculation/ui/tools/arc_clipper.dart';

class TopRoundBackground extends StatelessWidget {
  final Widget widget;

  TopRoundBackground({
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: ClipPath(
              clipper: new ArcClipper(),
              child: Stack(
                children: <Widget>[
                  new Container(
                    width: double.infinity,
                    child: widget,
                  )
                ],
              ),
            ),
          ),
          new Flexible(
            flex: 3,
            child: new Container(),
          )
        ],
      ),
    );
  }
}
