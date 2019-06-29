import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/models/sportprogram.dart';
import 'package:mon_guide_musculation/pages/home_page.dart';
import 'package:mon_guide_musculation/ui/pages/page_bodybuilding.dart';
import 'package:mon_guide_musculation/ui/states/common_refreshable_state.dart';
import 'package:mon_guide_musculation/ui/widgets/common_divider.dart';
import 'package:mon_guide_musculation/utils/constants.dart';

class SportProgramWidget extends StatelessWidget {
  final SportProgram sportProgram;

  const SportProgramWidget(
    this.sportProgram, {
    Key key,
  })  : assert(sportProgram != null),
        super(key: key);

  Widget _buildTile(BuildContext context) {
    return ListTile(
      title: Text(Texts.defaultSportProgramName),
      subtitle: Text(Texts.formatSportProgramWidgetDescription(sportProgram)),
      isThreeLine: true,
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        print(Managers.bodyBuildingManager.cachedExercices.length);
        if (Managers.bodyBuildingManager.cachedExercices.isEmpty) {
          HomePage.showSnackBar(SnackBar(
            content: Text(Texts.snackBarErrorNotFullyLoaded),
            action: SnackBarAction(
              label: Texts.snackBarButtonClose,
              onPressed: () {},
            ),
          ));
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SportProgramScreen(
                    sportProgram: sportProgram,
                  ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTile(context);
  }
}

class SportProgramItemWidget extends StatelessWidget {
  final SportProgramItem item;

  const SportProgramItemWidget(
    this.item, {
    Key key,
  })  : assert(item != null),
        super(key: key);

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
            name,
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SportProgramEvolutionScreen(item.parent),
                            ),
                          );
                        },
                        child: _buildIcon(Icons.show_chart),
                      ),
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
                  _buildObjectiveWidget(Texts.itemSportProgramNumberSeries, item.series, Icons.repeat),
                  Text(
                    Texts.itemSportProgramOfRepetitions,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.0),
                  ),
                  _buildObjectiveWidget(Texts.itemSportProgramNumberRepetitions, item.repetitions, Icons.format_list_numbered),
                  Text(
                    Texts.itemSportProgramAtWeight,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.0),
                  ),
                  _buildObjectiveWidget(Texts.itemSportProgramNumberSeries, item.weight, Icons.line_weight),
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

class SimpleSportProgramItemWidget extends StatelessWidget {
  final SportProgramItem item;

  const SimpleSportProgramItemWidget(
    this.item, {
    Key key,
  })  : assert(item != null),
        super(key: key);

  Widget _buildTile(BuildContext context) {
    return ListTile(
      title: Text(item.exercise.title),
      subtitle: Text(Texts.formatSportProgramItemSimpleItemDescription(item)),
      trailing: GestureDetector(
        child: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Constants.colorAccent,
        ),
        onTap: () => BodyBuildingExerciseReadingScreen.open(context, item.exercise),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTile(context);
  }
}

class SportProgramEvolutionGraphWidget extends StatelessWidget {
  final SportProgram item;
  final SportProgramEvolutionType evolutionType;

  const SportProgramEvolutionGraphWidget(
    this.item,
    this.evolutionType, {
    Key key,
  })  : assert(item != null),
        super(key: key);

  Widget _buildTile(BuildContext context) {
    return Card(
      child: Text(evolutionType.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTile(context);
  }
}

class SportProgramItemEvolutionGraphWidget extends StatelessWidget {
  final SportProgramItem item;
  final SportProgramEvolutionType evolutionType;

  const SportProgramItemEvolutionGraphWidget(
    this.item,
    this.evolutionType, {
    Key key,
  })  : assert(item != null),
        super(key: key);

  Widget _buildTile(BuildContext context) {
    return Card(
      child: Text(evolutionType.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTile(context);
  }
}

class SportProgramScreen extends StatefulWidget {
  final SportProgram sportProgram;

  SportProgramScreen({
    this.sportProgram,
  });

  @override
  State<SportProgramScreen> createState() {
    if (sportProgram != null) {
      return _SportProgramScreenItemsListingState(sportProgram);
    }

    return _SportProgramScreenSavedItemsListingState();
  }
}

class SportProgramImportScreen extends StatefulWidget {
  final String token;

  SportProgramImportScreen(
    this.token,
  ) : assert(token != null);

  @override
  State<SportProgramImportScreen> createState() {
    return _SportProgramImportScreenItemsListingState(token);
  }
}

class SportProgramEvolutionScreen extends StatefulWidget {
  final SportProgram sportProgram;
  final SportProgramEvolutionType evolutionType;

  SportProgramEvolutionScreen(
    this.sportProgram, {
    this.evolutionType,
  });

  @override
  State<SportProgramEvolutionScreen> createState() {
    if (evolutionType != null) {
      return _SportProgramEvolutionScreenTypeState(sportProgram, evolutionType);
    }

    return _SportProgramEvolutionScreenState(sportProgram);
  }
}

class _SportProgramScreenItemsListingState extends State<SportProgramScreen> {
  final SportProgram sportProgram;

  _SportProgramScreenItemsListingState(
    this.sportProgram,
  ) : assert(sportProgram != null);

  Widget _buildHeaderIcon(BuildContext context, IconData icon, String subtitle, void onTap()) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 2.0,
        vertical: 0.0,
      ),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 3.8,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.0,
              vertical: 8.0,
            ),
            child: Column(
              children: <Widget>[
                Icon(
                  icon,
                  size: 40,
                  color: Constants.colorAccent,
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.subtitle,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildHeaderIcon(context, Icons.play_circle_outline, Texts.sportProgramScreenButtonStart, () {}),
            _buildHeaderIcon(context, Icons.edit, Texts.sportProgramScreenButtonEdit, () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return SizedBox(
      child: SportProgramItemWidget(sportProgram.items[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(sportProgram.name),
        backgroundColor: Constants.colorAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(Texts.dialogTitleConfirm),
                    content: Text(Texts.dialogDescriptionConfirmRemove),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(Texts.buttonCancel),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      FlatButton(
                        child: Text(Texts.buttonRemove),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      )
                    ],
                  );
                },
              ).then((result) {
                if (result == null) {
                  return;
                }

                if (result as bool) {
                  Managers.sportProgramManager.remove(sportProgram);
                  Navigator.of(context).pop();
                }
              });
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          _buildHeaderCard(context),
          ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: sportProgram.items.length,
            itemBuilder: (context, index) => _buildItem(context, index),
          )
        ],
      ),
    );
  }
}

class _SportProgramScreenSavedItemsListingState extends CommonRefreshableState<SportProgramScreen, SportProgram> {
  @override
  void initialize() {
    Managers.sportProgramManager.useRefreshIndicatorKey(refreshIndicatorKey);
  }

  @override
  Future<void> getFuture() {
    return Managers.sportProgramManager.retriveSaved();
  }

  @override
  List<SportProgram> getNewItemListState() {
    return Managers.sportProgramManager.savedPrograms;
  }

  @override
  Widget buildItem(BuildContext context, List<SportProgram> items, int index) {
    return SizedBox(
      child: SportProgramWidget(items[index]),
    );
  }
}

class _SportProgramImportScreenItemsListingState extends CommonRefreshableState<SportProgramImportScreen, SportProgramItem> {
  final String token;

  _SportProgramImportScreenItemsListingState(
    this.token,
  );

  @override
  Future<void> getFuture() {
    return Managers.sportProgramManager.fetchByToken(token);
  }

  @override
  List<SportProgramItem> getNewItemListState() {
    return Managers.sportProgramManager.cachedProgram.items;
  }

  @override
  Color getBackgroundColor(BuildContext context) => Colors.white;

  @override
  List<Widget> itemsBefore(BuildContext context) {
    SportProgram sportProgram = items.isNotEmpty ? items[0].parent : null;

    if (sportProgram == null) {
      return null;
    }

    return <Widget>[
      Container(
        width: double.infinity,
        child: Center(
          child: Text(
            sportProgram.target,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      CommonDivider(),
    ];
  }

  @override
  Widget buildItem(BuildContext context, List<SportProgramItem> items, int index) {
    return SizedBox(
      child: SimpleSportProgramItemWidget(items[index]),
    );
  }
}

class _SportProgramEvolutionScreenState extends State<SportProgramEvolutionScreen> {
  final SportProgram sportProgram;

  _SportProgramEvolutionScreenState(
    this.sportProgram,
  ) : assert(sportProgram != null);

  @protected
  Widget buildGraph(BuildContext context, SportProgramEvolutionType evolutionType) {
    return SizedBox(
      child: Text(evolutionType.toString()),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return SizedBox(
      child: SportProgramEvolutionGraphWidget(sportProgram, SportProgramEvolutionType.values[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(Texts.evolutionScreenTitlePrefix + sportProgram.name),
        backgroundColor: Constants.colorAccent,
      ),
      body: ListView(
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: SportProgramEvolutionType.values.length,
            itemBuilder: (context, index) => _buildItem(context, index),
          )
        ],
      ),
    );
  }
}

class _SportProgramEvolutionScreenTypeState extends _SportProgramEvolutionScreenState {
  final SportProgramEvolutionType evolutionType;

  _SportProgramEvolutionScreenTypeState(
    SportProgram sportProgram,
    this.evolutionType,
  )   : assert(evolutionType != null),
        super(sportProgram);
}
