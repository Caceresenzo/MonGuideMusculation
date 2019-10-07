import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/models/sportprogram.dart';
import 'package:mon_guide_musculation/pages/home_page.dart';
import 'package:mon_guide_musculation/ui/pages/page_bodybuilding.dart';
import 'package:mon_guide_musculation/ui/pages/page_sportprogram_creator.dart';
import 'package:mon_guide_musculation/ui/states/common_refreshable_state.dart';
import 'package:mon_guide_musculation/ui/widgets/common_divider.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:mon_guide_musculation/utils/functions.dart';

class SportProgramWidget extends StatelessWidget {
  final SportProgram sportProgram;

  const SportProgramWidget(
    this.sportProgram, {
    Key key,
  })  : assert(sportProgram != null),
        super(key: key);

  Widget _buildTile(BuildContext context) {
    return ListTile(
      title: Text(sportProgram.name()),
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
              builder: (context) {
                return SportProgramScreen(
                  sportProgram: sportProgram,
                );
              },
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

  Widget _buildObjectiveWidget(String name, num value, IconData icon) {
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
                          BodyBuildingExerciseEvolutionScreen.open(context, [item.exercise]);
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
                  _buildObjectiveWidget(Texts.itemSportProgramNumberWeight, item.safeWeight, Icons.line_weight),
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

class SportProgramStartScreen extends StatefulWidget {
  final SportProgram sportProgram;

  SportProgramStartScreen(
    this.sportProgram,
  ) : assert(sportProgram != null);

  @override
  State<SportProgramStartScreen> createState() {
    return _SportProgramStartScreenMainState(sportProgram);
  }
}

class _SportProgramScreenItemsListingState extends State<SportProgramScreen> {
  final GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey();
  final SportProgram sportProgram;

  _SportProgramScreenItemsListingState(
    this.sportProgram,
  ) : assert(sportProgram != null);

  void _onStartScreenFinished(result) {
    if (result == null || result == false) {
      return;
    }

    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: new Text(
              Texts.dialogTitleWellDone,
              style: const TextStyle(
                color: Constants.colorAccent,
              ),
              textAlign: TextAlign.center,
            ),
            elevation: 0.0,
            content: Text(Texts.sportProgramDialogWantToSeeProgression),
            actions: <Widget>[
              FlatButton(
                child: Text(Texts.buttonClose),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(Texts.buttonShow),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BodyBuildingExerciseEvolutionScreen(sportProgram.toExerciseList()),
                    ),
                  );
                },
              )
            ],
          );
        }).then((_) => null /*_onStartScreenFinished(true)*/);
  }

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
            _buildHeaderIcon(context, Icons.show_chart, Texts.sportProgramScreenButtonEvolution, () {
              BodyBuildingExerciseEvolutionScreen.open(context, sportProgram.toExerciseList());
            }),
            _buildHeaderIcon(context, Icons.play_circle_outline, Texts.sportProgramScreenButtonStart, () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => SportProgramStartScreen(sportProgram),
                    ),
                  )
                  .then((result) => _onStartScreenFinished(result));
            }),
            _buildHeaderIcon(context, Icons.edit, Texts.sportProgramScreenButtonEdit, () {
              final String currentName = sportProgram.name();
              TextEditingController controller = new TextEditingController(
                text: currentName,
              );

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      Texts.dialogTitleEdit,
                      style: const TextStyle(
                        color: Constants.colorAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    elevation: 0.0,
                    content: ListView(
                      children: <Widget>[
                        new Theme(
                          data: new ThemeData(
                            primaryColor: Constants.colorAccent,
                            accentColor: Constants.colorAccent,
                          ),
                          child: TextFormField(
                            controller: controller,
                            cursorColor: Constants.colorAccent,
                            maxLines: 1,
                            maxLength: 100,
                            decoration: InputDecoration(
                              labelText: Texts.remameSportProgramDecorationLabelName,
                            ),
                          ),
                        ),
                        RaisedButton(
                          onPressed: sportProgram.isCustom
                              ? () {
                                  Navigator.of(context).pop(false);
                                  SportProgramCreatorScreen.open(context, sportProgram: sportProgram);
                                }
                              : null,
                          color: Constants.colorAccent,
                          elevation: 0.0,
                          disabledElevation: 0.0,
                          highlightElevation: 0.0,
                          child: Text(
                            Texts.buttonEdit,
                            style: Theme.of(context).textTheme.button.copyWith(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(Texts.buttonConfirm),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  );
                },
              ).then((_) {
                final String newName = controller.text;

                if (Managers.sportProgramManager.rename(sportProgram, newName)) {
                  _scaffoldState.currentState.hideCurrentSnackBar();
                  _scaffoldState.currentState.showSnackBar(SnackBar(
                    content: Text(Texts.sportProgramRenamed),
                    action: SnackBarAction(
                      label: Texts.snackBarButtonClose,
                      onPressed: () {},
                    ),
                  ));

                  setState(() {});
                }
              });
            }),
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
      key: _scaffoldState,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(sportProgram.name()),
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
  Widget buildBottomBar(BuildContext context) {
    return Row(
      children: <Widget>[
        _buildActionButton(Icons.show_chart, () {
          Managers.bodyBuildingManager.fetch(true).then((_) {
            BodyBuildingExerciseEvolutionScreen.open(context, Managers.bodyBuildingManager.cachedExercices);
          });
        }),
        _buildActionButton(Icons.add, () {
          SportProgramCreatorScreen.open(context);
        }),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, void onTap()) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 0.0,
        ),
        child: RaisedButton(
          elevation: 0.0,
          onPressed: onTap,
          highlightElevation: 0.0,
          color: Constants.colorAccent,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
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

class _SportProgramStartScreenMainState extends State<SportProgramStartScreen> with WidgetsBindingObserver {
  static const Duration tickDuration = Duration(milliseconds: 500);

  final GlobalKey<ScaffoldState> _scaffoldStateKey = new GlobalKey();
  final SportProgram sportProgram;
  int _currentItemIndex;
  Timer _tickingTimer;
  Duration _currentDuration;

  _SportProgramStartScreenMainState(
    this.sportProgram,
  ) : assert(sportProgram != null);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _currentItemIndex = 0;
    _tickingTimer = Timer.periodic(tickDuration, _tickingTimerCallback);
    _resetCurrentDuration();
  }

  void _tickingTimerCallback(timer) {
    setState(() {
      _currentDuration += tickDuration;
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

    _tickingTimer.cancel();
  }

  bool canSelectNext() => currentIndex + 1 != itemCount;
  void selectNext() => _selectIndex(_currentItemIndex + 1);

  bool canSelectPrevious() => currentIndex != 0;
  void selectPrevious() => _selectIndex(_currentItemIndex - 1);

  void _selectIndex(int index) {
    setState(() {
      _resetCurrentDuration();
      _currentItemIndex = index;
    });
  }

  void selectExit() {
    _selectWayOut(Texts.sportProgramSnackBarQuit, Texts.sportProgramSnackBarButtonYes, () {
      Navigator.of(context).pop(false);
    });
  }

  void selectEnd() {
    _selectWayOut(Texts.sportProgramSnackBarFinish, Texts.sportProgramSnackBarButtonYes, () {
      Managers.bodyBuildingManager.notifySportProgramFinished(sportProgram);
      Navigator.of(context).pop(true);
    });
  }

  void _selectWayOut(String text, String buttonLabel, void onPressed()) {
    _scaffoldStateKey.currentState.removeCurrentSnackBar(
      reason: SnackBarClosedReason.hide,
    );
    _scaffoldStateKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: buttonLabel,
        onPressed: onPressed,
      ),
    ));
  }

  void _resetCurrentDuration() {
    _currentDuration = Duration();
  }

  SportProgramItem get currentItem => sportProgram.items[_currentItemIndex];
  int get currentIndex => _currentItemIndex;
  int get itemCount => sportProgram.items.length;

  Widget _buildObjectiveBoard() {
    TextStyle mainTextStyle = Theme.of(context).textTheme.headline.copyWith(fontSize: 34.0);

    double screenWidth = MediaQuery.of(context).size.width;

    double firstColumnWidth = screenWidth / 8;
    double valueColumnWidth = screenWidth / 5;
    double wordColumnWidth = screenWidth / 1.8;

    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            Texts.sportProgramObjectives,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.body1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    width: firstColumnWidth,
                    child: Text(
                      "",
                      style: mainTextStyle,
                    ),
                  ),
                  SizedBox(
                    width: firstColumnWidth,
                    child: Text(
                      Texts.itemSportProgramOfRepetitions,
                      textAlign: TextAlign.right,
                      style: mainTextStyle,
                    ),
                  ),
                  SizedBox(
                    width: firstColumnWidth,
                    child: Text(
                      Texts.itemSportProgramAtWeight,
                      textAlign: TextAlign.right,
                      style: mainTextStyle,
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    width: valueColumnWidth,
                    child: Text(
                      currentItem.series.toString(),
                      textAlign: TextAlign.right,
                      style: mainTextStyle,
                    ),
                  ),
                  SizedBox(
                    width: valueColumnWidth,
                    child: Text(
                      currentItem.repetitions.toString(),
                      textAlign: TextAlign.right,
                      style: mainTextStyle,
                    ),
                  ),
                  SizedBox(
                    width: valueColumnWidth,
                    child: Text(
                      currentItem.safeWeight.toString(),
                      textAlign: TextAlign.right,
                      style: mainTextStyle,
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    width: wordColumnWidth,
                    child: Text(
                      Texts.itemSportProgramNumberSeries,
                      style: mainTextStyle,
                    ),
                  ),
                  SizedBox(
                    width: wordColumnWidth,
                    child: Text(
                      Texts.itemSportProgramNumberRepetitions,
                      style: mainTextStyle,
                    ),
                  ),
                  SizedBox(
                    width: wordColumnWidth,
                    child: Text(
                      Texts.itemSportProgramNumberWeight,
                      style: mainTextStyle,
                    ),
                  )
                ],
              )
            ],
          ),
          /*Text(
              "       ${currentItem.series}${Texts.itemSportProgramNumberSeries}\n ${Texts.itemSportProgramOfRepetitions} ${currentItem.repetitions}${Texts.itemSportProgramNumberRepetitions}\n   ${Texts.itemSportProgramAtWeight}  ${currentItem.weight}${Texts.itemSportProgramNumberWeight}",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.display1,
            ),*/
        ],
      ),
    );
  }

  Widget _buildTimer() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Text(
          formatDuration(_currentDuration),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline.copyWith(fontSize: 48.0, color: Constants.colorAccent),
        ),
      ),
    );
  }

  Widget _buildBottomButton(String text, TextAlign align, void onTap()) {
    assert(align != TextAlign.left || align != TextAlign.right);

    List<Widget> widgets = new List();
    widgets.add(
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 0.0,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.button.copyWith(fontSize: 18, color: Constants.colorAccent),
        ),
      ),
    );

    bool left = align == TextAlign.left;

    widgets.insert(left ? 0 : widgets.length, Icon(left ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right));
    widgets.insert(
        left ? 0 : widgets.length,
        SizedBox(
          width: 8.0,
        ));

    return InkWell(
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width / 2,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: widgets,
            mainAxisAlignment: left ? MainAxisAlignment.start : MainAxisAlignment.end,
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldStateKey,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(sportProgram.name()),
        backgroundColor: Constants.colorAccent,
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "${currentIndex + 1} / $itemCount",
                style: Theme.of(context).textTheme.body2,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              BodyBuildingExerciseReadingScreen.open(context, currentItem.exercise);
            },
            child: Column(
              children: <Widget>[
                Container(
                  child: Text(
                    currentItem.exercise.muscle.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    currentItem.exercise.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline,
                  ),
                ),
                SizedBox(
                  height: 8.0,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 0.0,
            ),
            child: CommonDivider(
              customHeight: 0.0,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          _buildObjectiveBoard(),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: (56.0 + 72),
        child: Column(
          children: <Widget>[
            CommonDivider(
              customHeight: 0.0,
            ),
            _buildTimer(),
            Container(
              height: 56,
              child: Row(
                children: <Widget>[
                  _buildBottomButton(Texts.sportProgramButtonPreviousItem, TextAlign.left, () {
                    if (canSelectPrevious()) {
                      selectPrevious();
                    } else {
                      selectExit();
                    }
                  }),
                  _buildBottomButton(Texts.sportProgramButtonNextItem, TextAlign.right, () {
                    if (canSelectNext()) {
                      selectNext();
                    } else {
                      selectEnd();
                    }
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
