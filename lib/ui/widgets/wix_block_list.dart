import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/models/wix.dart';
import 'package:mon_guide_musculation/utils/constants.dart';

class WixBlockList extends StatelessWidget {
  final List<List<WixBlockItem>> allItems;

  const WixBlockList({Key key, this.allItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true, // todo comment this out and check the result
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, position) {
        List<WixBlockItem> widgets = allItems[position];

        bool firstIsTitle = widgets[0].isTitle();
        int offset = firstIsTitle ? 1 : 0;

        return Card(
          child: Column(
            children: <Widget>[
              firstIsTitle
                  ? Card(
                      child: Container(
                        width: double.infinity,
                        child: widgets[0].toWidget(context),
                      ),
                      color: Constants.colorAccent,
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 5.0,
                ),
                child: ListView.builder(
                  shrinkWrap: true, // todo comment this out and check the result
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, position) {
                    Widget widget = widgets[position + offset].toWidget(context);

                    return widget;
                  },
                  itemCount: widgets.length - offset,
                ),
              )
            ],
          ),
          color: Colors.white,
        );
      },
      itemCount: allItems.length,
    );
  }
}
