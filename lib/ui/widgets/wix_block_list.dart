import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/models/wix.dart';
import 'package:mon_guide_musculation/ui/widgets/card_info.dart';
import 'package:mon_guide_musculation/utils/constants.dart';

class WixBlockList extends StatelessWidget {
  final List<List<WixBlockItem>> allItems;

  const WixBlockList({Key key, this.allItems}) : super(key: key);

  Widget _buildNoContentCard() {
    return InfoCard(
      icon: Icons.alternate_email,
      text: Texts.pageNoContent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true, // todo comment this out and check the result
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, position) {
        if (allItems.length == 0) {
          return _buildNoContentCard();
        }

        List<WixBlockItem> widgets = allItems[position];

        if (widgets.length == 0) {
          return _buildNoContentCard();
        }

        bool firstIsTitle = widgets[0].isTitle();
        int offset = firstIsTitle ? 1 : 0;

        return Card(
          elevation: 0.0,
          child: Column(
            children: <Widget>[
              firstIsTitle
                  ? Card(
                      elevation: 0.0,
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
