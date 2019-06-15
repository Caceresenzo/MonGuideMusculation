import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/models/sportprogram.dart';
import 'package:mon_guide_musculation/ui/pages/page_bodybuilding.dart';
import 'package:mon_guide_musculation/ui/states/common_refreshable_state.dart';
import 'package:mon_guide_musculation/ui/widgets/common_divider.dart';
import 'package:mon_guide_musculation/utils/constants.dart';

class SportProgramItemWidget extends StatelessWidget {
  final SportProgramItem item;

  const SportProgramItemWidget(
    this.item, {
    Key key,
  }) : super(key: key);

  Widget _buildIcon(IconData icon) {
    return Icon(
      icon,
      size: 28.0,
      color: Constants.colorAccent,
    );
  }

  Widget _buildObjectiveWidget(String name, int value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 0.0,
        horizontal: 16.0,
      ),
      child: Column(
        children: <Widget>[
          //_buildIcon(icon),
          Text(
            value.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.0),
          ),
          Text(
            /*value.toString() + "\n" + */ name,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 12.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      item.exercise.title,
                      style: Theme.of(context).textTheme.body2,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 8.0,
                      ),
                      _buildIcon(Icons.show_chart),
                      SizedBox(
                        width: 8.0,
                      ),
                      GestureDetector(
                        child: _buildIcon(Icons.info),
                        onTap: () {
                          BodyBuildingExerciseReadingScreen.open(context, item.exercise);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            CommonDivider(),
            SizedBox(
              height: 4.0,
            ),
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildObjectiveWidget(" séries", item.series, Icons.repeat),
                  Text(
                    "de",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.0),
                  ),
                  _buildObjectiveWidget(" répétitions", item.repetitions, Icons.format_list_numbered),
                  Text(
                    "à",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.0),
                  ),
                  _buildObjectiveWidget(" kg", item.weight, Icons.line_weight),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCard(context);
  }
}

class SportProgramScreen extends StatefulWidget {
  @override
  State<SportProgramScreen> createState() {
    return _SportProgramScreenItemsListingState();
  }
}

class _SportProgramScreenItemsListingState extends CommonRefreshableState<SportProgramScreen, SportProgramItem> {
  @override
  Future<void> getFuture() {
    return Managers.sportProgramManager.fetchByToken("JUgNTgJAIVzy6hFBudhy9WrXfpuCYvXxFH9ulMXBHssf47KsiavnOq6brpyAzhs2");
  }

  @override
  List<SportProgramItem> getNewItemListState() {
    print(Managers.sportProgramManager.cachedProgram.items);

    return Managers.sportProgramManager.cachedProgram.items;
  }

  @override
  Widget buildItem(BuildContext context, List<SportProgramItem> items, int index) {
    return SizedBox(
      child: SportProgramItemWidget(items[index]),
    );
  }
}
