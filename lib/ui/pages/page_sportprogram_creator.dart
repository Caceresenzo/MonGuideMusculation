import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/models/bodybuilding.dart';
import 'package:mon_guide_musculation/models/sportprogram.dart';
import 'package:mon_guide_musculation/ui/pages/page_bodybuilding.dart';
import 'package:mon_guide_musculation/ui/widgets/card_info.dart';
import 'package:mon_guide_musculation/ui/widgets/common_divider.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:mon_guide_musculation/utils/functions.dart';

class SportProgramItemData {
  SportProgramItemData(this.object, this.key);

  final SportProgramItem object;
  final Key key;
}

class _CustomPopupMenu {
  static _CustomPopupMenu delete = _CustomPopupMenu(title: "SUPPRIMER", icon: Icons.delete);
  static _CustomPopupMenu edit = _CustomPopupMenu(title: "EDITER", icon: Icons.edit);

  static List<_CustomPopupMenu> items = <_CustomPopupMenu>[edit, delete];

  _CustomPopupMenu({this.title, this.icon});

  String title;
  IconData icon;
}

class SportProgramItemWidget extends StatelessWidget {
  final _SportProgramCreatorState parent;
  final SportProgramItemData data;
  final bool isFirst;
  final bool isLast;

  SportProgramItemWidget({
    this.parent,
    this.data,
    this.isFirst,
    this.isLast,
  });

  Widget _buildItemInfo(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              data.object.exercise.title,
              style: Theme.of(context).textTheme.subhead,
            ),
            Text(
              Texts.formatSportProgramItemSimpleItemDescription(data.object),
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        cardColor: Constants.colorAccent,
      ),
      child: PopupMenuButton<_CustomPopupMenu>(
        elevation: 0.0,
        icon: Icon(
          Icons.more_vert,
          color: Constants.colorAccent,
        ),
        onSelected: (_CustomPopupMenu choice) {
          if (choice == _CustomPopupMenu.delete) {
            parent.notifyDelete(this);
          }

          if (choice == _CustomPopupMenu.edit) {
            parent.notifyEdit(this);
          }
        },
        itemBuilder: (BuildContext context) {
          return _CustomPopupMenu.items.map((_CustomPopupMenu choice) {
            return PopupMenuItem<_CustomPopupMenu>(
              value: choice,
              child: ListTile(
                leading: Icon(
                  choice.icon,
                  color: Colors.white,
                ),
                title: Text(
                  choice.title,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }).toList();
        },
      ),
    );
  }

  Widget _buildDragHandle(BuildContext context) {
    return ReorderableListener(
      child: Container(
        padding: EdgeInsets.only(right: 18.0, left: 18.0),
        color: Color(0x08000000),
        child: Center(
          child: Icon(
            Icons.reorder,
            color: Constants.colorAccent,
          ),
        ),
      ),
    );
  }

  Widget _buildChild(BuildContext context, ReorderableItemState state) {
    BoxDecoration decoration;

    if (state == ReorderableItemState.dragProxy || state == ReorderableItemState.dragProxyFinished) {
      // slightly transparent background white dragging (just like on iOS)
      decoration = BoxDecoration(color: Color(0xD0FFFFFF));
    } else {
      bool placeholder = state == ReorderableItemState.placeholder;
      decoration = BoxDecoration(
          border: Border(
              top: isFirst && !placeholder
                  ? Divider.createBorderSide(context) //
                  : BorderSide.none,
              bottom: isLast && placeholder
                  ? BorderSide.none //
                  : Divider.createBorderSide(context)),
          color: placeholder ? null : Colors.white);
    }

    return Container(
      decoration: decoration,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Opacity(
          // hide content for placeholder
          opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildItemInfo(context),
                _buildPopupMenu(context),
                _buildDragHandle(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
      key: data.key,
      childBuilder: _buildChild,
    );
  }
}

class _AddNewExerciseScreen extends StatefulWidget {
  final _SportProgramCreatorState sportProgramCreatorState;
  final SportProgramItemData sportProgramItemData;

  const _AddNewExerciseScreen(this.sportProgramCreatorState, {Key key, this.sportProgramItemData}) : super(key: key);

  @override
  _AddNewExerciseScreenState createState() => _AddNewExerciseScreenState(sportProgramCreatorState).editIfNotNull(sportProgramItemData);

  static void open(BuildContext context, _SportProgramCreatorState _sportProgramCreatorState, {SportProgramItemData edit}) {
    navigatorPush(
      context,
      _AddNewExerciseScreen(
        _sportProgramCreatorState,
        sportProgramItemData: edit,
      ),
    );
  }
}

class _AddNewExerciseScreenState extends State<_AddNewExerciseScreen> {
  final _SportProgramCreatorState sportProgramCreatorState;

  SportProgramItemData inEditItem;

  BodyBuildingExercise _selectedExercise;
  int _series = 1;
  int _repetitions = 10;
  double _weight = 0;

  _AddNewExerciseScreenState(this.sportProgramCreatorState);

  void _onExerciseReceive(BodyBuildingExercise exercise) {
    Navigator.of(context)..pop()..pop();

    setState(() {
      _selectedExercise = exercise;
    });
  }

  Widget _buildSelectedExerciseTile(BuildContext context) {
    dynamic onTap = () {
      navigatorPush(
        context,
        BodyBuildingScreen(
          onTapOverride: _onExerciseReceive,
          forceAppBar: true,
        ),
      );
    };

    return Card(
      elevation: 0.0,
      child: Builder(
        builder: (context) {
          if (_selectedExercise == null) {
            return ListTile(
              title: Text("Choisir un exercice"),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: onTap,
            );
          }

          return ListTile(
            title: Text(_selectedExercise.title),
            subtitle: Text("Cliquez pour changer l'exercice"),
            trailing: GestureDetector(
              child: Icon(
                Icons.info,
                color: Constants.colorAccent,
              ),
              onTap: () {
                BodyBuildingExerciseReadingScreen.open(context, _selectedExercise);
              },
            ),
            onTap: onTap,
          );
        },
      ),
    );
  }

  _buildSlider(BuildContext context, String label, double value, void onChanged(double newValue), {double min = 0.0, double max = 50.0}) {
    return Card(
      elevation: 0.0,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Text(
              label,
              style: Theme.of(context).textTheme.subtitle,
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 50.0,
                  child: Center(
                    child: Text(safeNumber(value).toString()),
                  ),
                ),
                Expanded(
                  child: Slider(
                    activeColor: Constants.colorAccent,
                    value: value,
                    min: min,
                    max: max,
                    divisions: (max * 2).toInt(), // Allow for 0.5
                    onChanged: onChanged,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ajouter un exercice"),
          backgroundColor: Constants.colorAccent,
          elevation: 0.0,
        ),
        body: ListView(
          children: <Widget>[
            _buildSelectedExerciseTile(context),
            _buildSlider(context, "Séries", _series.toDouble(), (newValue) {
              setState(() {
                _series = newValue.toInt();
              });
            }, min: 1),
            _buildSlider(context, "Répétitions", _repetitions.toDouble(), (newValue) {
              setState(() {
                _repetitions = newValue.toInt();
              });
            }, min: 1),
            _buildSlider(context, "Poids (kg)", _weight, (newValue) {
              setState(() {
                _weight = (newValue * 10).round() / 10;
              });
            }),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(8),
          child: RaisedButton(
            onPressed: _selectedExercise == null
                ? null
                : () {
                    Navigator.of(context).pop();

                    if (inEditItem != null) {
                      sportProgramCreatorState.modifiedItem(inEditItem, _selectedExercise, _series, _repetitions, _weight);
                    } else {
                      sportProgramCreatorState.newItem(_selectedExercise, _series, _repetitions, _weight);
                    }
                  },
            child: Text(
              inEditItem != null ? "MODIFIER" : "AJOUTER",
              style: Theme.of(context).textTheme.button.copyWith(color: Colors.white),
            ),
            elevation: 0.0,
            disabledElevation: 0.0,
            highlightElevation: 0.0,
            color: Constants.colorAccent,
          ),
        ),
      ),
    );
  }

  _AddNewExerciseScreenState editIfNotNull(SportProgramItemData sportProgramItemData) {
    if (sportProgramItemData == null) {
      return this;
    }

    inEditItem = sportProgramItemData;

    _selectedExercise = sportProgramItemData.object.exercise;
    _series = sportProgramItemData.object.series;
    _repetitions = sportProgramItemData.object.repetitions;
    _weight = sportProgramItemData.object.weight;

    return this;
  }

  _AddNewExerciseScreenState duplicateIfNotNull(SportProgramItemData sportProgramItemData) {
    if (sportProgramItemData == null) {
      return this;
    }

    editIfNotNull(sportProgramItemData);
    inEditItem = null;

    return this;
  }
}

class SportProgramCreatorScreen extends StatefulWidget {
  final SportProgram _sportProgram;

  const SportProgramCreatorScreen({Key key, SportProgram sportProgram})
      : this._sportProgram = sportProgram,
        super(key: key);

  @override
  _SportProgramCreatorState createState() => _SportProgramCreatorState(_sportProgram ?? SportProgram.empty());

  static void open(BuildContext context, {SportProgram sportProgram}) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SportProgramCreatorScreen(
            sportProgram: sportProgram,
          ),
    ));
  }
}

class _SportProgramCreatorState extends State<SportProgramCreatorScreen> {
  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey();
  final ScrollController _controller = ScrollController();

  final SportProgram _sportProgram;
  List<SportProgramItemData> _items;

  int itemKeyIncrement = 0;

  _SportProgramCreatorState(SportProgram sportProgram)
      : assert(sportProgram != null),
        assert(sportProgram.isCustom),
        this._sportProgram = sportProgram {
    _items = new List();

    for (int i = 0; i < _sportProgram.items.length; ++i) {
      _items.add(SportProgramItemData(_sportProgram.items[i], _getNextKey()));
    }
  }

  Key _getNextKey() {
    return ValueKey(itemKeyIncrement++);
  }

  void _save() {
    _sportProgram.items.clear();
    _sportProgram.items.addAll(_items.map((item) => item.object).toList());

    Managers.sportProgramManager.pushCustom(_sportProgram);

    _scaffoldStateKey.currentState..removeCurrentSnackBar();
    _scaffoldStateKey.currentState.showSnackBar(SnackBar(
      content: Text("Modification enregistré."),
    ));
  }

  int _indexOfKey(Key key) {
    return _items.indexWhere((SportProgramItemData item) => item.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    final draggedItem = _items[draggingIndex];
    setState(() {
      debugPrint("Reordering $item -> $newPosition");
      _items.removeAt(draggingIndex);
      _items.insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  void _reorderDone(Key item) {
    final draggedItem = _items[_indexOfKey(item)];
    debugPrint("Reordering finished for ${draggedItem.object.exercise.title}");
  }

  void notifyDelete(SportProgramItemWidget sportProgramItemWidget) {
    setState(() {
      _items.remove(sportProgramItemWidget.data);
    });
  }

  void notifyEdit(SportProgramItemWidget sportProgramItemWidget) {
    _AddNewExerciseScreen.open(
      context,
      this,
      edit: sportProgramItemWidget.data,
    );
  }

  void newItem(BodyBuildingExercise selectedExercise, int series, int repetitions, double weight) {
    _items.add(new SportProgramItemData(
        new SportProgramItem(
          parent: _sportProgram,
          exercise: selectedExercise,
          series: series,
          repetitions: repetitions,
          weight: weight,
        ),
        _getNextKey()));

    setState(() {});

    Future.delayed(Duration(milliseconds: 10)).then((_) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
  }

  void modifiedItem(SportProgramItemData originalItem, BodyBuildingExercise selectedExercise, int series, int repetitions, double weight) {
    int index = _items.indexOf(originalItem);

    SportProgramItemData modifiedItem = SportProgramItemData(
        new SportProgramItem(
          parent: _sportProgram,
          exercise: selectedExercise,
          series: series,
          repetitions: repetitions,
          weight: weight,
        ),
        _getNextKey());

    setState(() {
      _items.removeAt(index);
      _items.insert(index, modifiedItem);
    });
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (context) {
            Widget _buildButton(bool raised, String text, dynamic returnValue) {
              Text child = Text(
                text.toUpperCase(),
                style: Theme.of(context).textTheme.button.copyWith(color: raised ? Colors.white : Constants.colorAccent),
              );

              void onPressed() {
                Navigator.of(context).pop(returnValue);
              }

              if (raised) {
                return RaisedButton(
                  onPressed: onPressed,
                  child: child,
                  elevation: 0.0,
                  highlightElevation: 0.0,
                  color: Constants.colorAccent,
                );
              }

              return FlatButton(
                onPressed: onPressed,
                child: child,
              );
            }

            return AlertDialog(
              title: buildBasicDialogTitle(Texts.dialogTitleConfirm),
              content: Text("Voulez vous enregistrer avant de quitter ?"),
              elevation: 0.0,
              actions: <Widget>[
                _buildButton(false, "Anuler", null),
                _buildButton(false, "Non", false),
                _buildButton(true, "Oui", true),
              ],
            );
          },
        ).then((result) {
          if (result == null) {
            return false;
          }

          if (result as bool) {
            _save();
          }

          return true;
        });
      },
      child: Scaffold(
        key: _scaffoldStateKey,
        appBar: AppBar(
          title: Text("Creation"),
          backgroundColor: Constants.colorAccent,
          elevation: 0.0,
        ),
        body: ReorderableList(
          onReorder: this._reorderCallback,
          onReorderDone: this._reorderDone,
          child: Builder(
            builder: (context) {
              if (_items.isEmpty) {
                return ListView(
                  children: <Widget>[
                    InfoCard.templateEmpty(),
                  ],
                );
              }

              return ListView.builder(
                controller: _controller,
                itemCount: _items.length,
                itemBuilder: (BuildContext context, int index) {
                  return SportProgramItemWidget(
                    parent: this,
                    data: _items[index],
                    // first and last attributes affect border drawn during dragging
                    isFirst: index == 0,
                    isLast: index == _items.length - 1,
                  );
                },
              );
            },
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 72.0,
          child: Column(
            children: <Widget>[
              CommonDivider(
                customHeight: 0.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      heroTag: null,
                      elevation: 0.0,
                      highlightElevation: 0.0,
                      child: Icon(Icons.add),
                      onPressed: () {
                        _AddNewExerciseScreen.open(context, this);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      heroTag: null,
                      elevation: 0.0,
                      highlightElevation: 0.0,
                      child: Icon(Icons.save),
                      onPressed: () {
                        _save();
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
