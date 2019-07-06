import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/logic/managers/bodybuilding_manager.dart';
import 'package:mon_guide_musculation/models/bodybuilding.dart';
import 'package:mon_guide_musculation/ui/states/common_refreshable_state.dart';
import 'package:mon_guide_musculation/ui/widgets/card_info.dart';
import 'package:mon_guide_musculation/ui/widgets/common_divider.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:mon_guide_musculation/utils/functions.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:charts_flutter/flutter.dart' as charts;
//import 'package:flutter_html_view/flutter_html_view.dart';

class BodyBuildingMuscleWidget extends StatelessWidget {
  final BodyBuildingMuscle muscle;

  const BodyBuildingMuscleWidget(
    this.muscle, {
    Key key,
  })  : assert(muscle != null),
        super(key: key);

  Widget _buildTile(BuildContext context) => ListTile(
        leading: muscle.iconImageReference != null
            ? SizedBox(
                width: 72,
                child: networkImage(
                  muscle.iconImageReference.toFullUrl(
                    resize: Constants.resizeBodyBuildingMuscleImage,
                  ),
                ),
              )
            : null,
        title: Text(muscle.title),
        subtitle: Text(Texts.exerciseCount(muscle.exercises.length)),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BodyBuildingScreen(
                    muscle: muscle,
                  ),
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return _buildTile(context);
  }
}

class BodyBuildingExerciseWidget extends StatelessWidget {
  final BodyBuildingExercise exercise;

  const BodyBuildingExerciseWidget(this.exercise, {Key key, BodyBuildingExerciseType typeFilter})
      : assert(exercise != null),
        super(key: key);

  Widget _buildTile(BuildContext context) => ListTile(
        title: Text(exercise.title),
        // subtitle: Text(exercise.shortDescription ?? Texts.itemMuscleNoShortDescription),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          BodyBuildingExerciseReadingScreen.open(context, exercise);
        },
      );

  @override
  Widget build(BuildContext context) {
    return _buildTile(context);
  }
}

class BodyBuildingScreen extends StatefulWidget {
  final BodyBuildingMuscle muscle;

  const BodyBuildingScreen({
    Key key,
    this.muscle,
  }) : super(key: key);

  @override
  State<BodyBuildingScreen> createState() {
    if (muscle != null) {
      return _BodyBuildingScreenExerciseByMuscleListingState(muscle);
    }

    return _BodyBuildingScreenMuscleListingState();
  }
}

class _BodyBuildingScreenMuscleListingState extends CommonRefreshableState<BodyBuildingScreen, BodyBuildingMuscle> {
  @override
  Future<void> getFuture() {
    return Managers.bodyBuildingManager.fetch(!hasInitialized());
  }

  @override
  List<BodyBuildingMuscle> getNewItemListState() {
    return Managers.bodyBuildingManager.cachedMuscles;
  }

  @override
  void onItemUpdated(BuildContext context) {
    int invalidEntryCount = Managers.bodyBuildingManager.invalidEntryCount;

    if (invalidEntryCount != 0) {
      Scaffold.of(context).showSnackBar(buildErrorSnackBar(
        message: Texts.invalidEntryCount(invalidEntryCount),
      ));
    }
  }

  @override
  Widget buildItem(BuildContext context, List<BodyBuildingMuscle> items, int index) {
    return SizedBox(
      child: BodyBuildingMuscleWidget(items[index]),
    );
  }
}

class _BodyBuildingScreenExerciseByMuscleListingState extends State<BodyBuildingScreen> {
  final BodyBuildingMuscle muscle;

  _BodyBuildingScreenExerciseByMuscleListingState(this.muscle);

  List<BodyBuildingExercise> items = new List();
  List<BodyBuildingExercise> _allItems = new List();

  List<DropdownMenuItem<BodyBuildingExerciseType>> _dropDownMenuItems;
  BodyBuildingExerciseType _currentExerciseType;

  @override
  void initState() {
    _allItems = muscle.exercises;
    items.addAll(_allItems);

    if (_allItems.isNotEmpty) {
      _dropDownMenuItems = getDropDownMenuItems();
      _currentExerciseType = _dropDownMenuItems[0].value;
    }
    super.initState();
  }

  Widget _buildItem(BuildContext context, List<BodyBuildingExercise> items, int index) {
    return SizedBox(
      child: BodyBuildingExerciseWidget(items[index]),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    if (_allItems.isEmpty) {
      return null;
    }

    return BottomAppBar(
      color: Constants.colorAccent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: new Theme(
                data: Theme.of(context).copyWith(canvasColor: Constants.colorAccent),
                child: DropdownButtonHideUnderline(
                  child: new DropdownButton<BodyBuildingExerciseType>(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    value: _currentExerciseType,
                    items: _dropDownMenuItems,
                    onChanged: (exerciseType) {
                      setState(() {
                        _currentExerciseType = exerciseType;

                        items = _allItems.where((exercise) {
                          if (_currentExerciseType == null) {
                            return true;
                          }

                          return exercise.type != null && exercise.type == _currentExerciseType;
                        }).toList();
                      });
                    },
                    iconEnabledColor: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<BodyBuildingExerciseType>> getDropDownMenuItems() {
    List<BodyBuildingExerciseType> types = [null];
    types.addAll(Managers.bodyBuildingManager.cachedExerciceTypes);

    List<DropdownMenuItem<BodyBuildingExerciseType>> items = new List();
    types.forEach((type) {
      items.add(new DropdownMenuItem(
        value: type,
        child: new Text(
          type == null ? Texts.exerciseSelectorAll : (Texts.exerciseSelectorItemPrefix + type.title).toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ));
    });

    return items;
  }

  @override
  Widget build(BuildContext context) {
    print("Building " + items.length.toString() + " item(s).");

    return Scaffold(
      appBar: AppBar(
        title: Text(muscle.title),
        backgroundColor: Constants.colorAccent,
      ),
      bottomNavigationBar: _buildBottomBar(context),
      body: items.isEmpty
          ? ListView(
              children: <Widget>[InfoCard.templateNoContent()],
            )
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildItem(context, items, index);
              },
            ),
    );
  }
}

class BodyBuildingExerciseReadingScreen extends StatelessWidget {
  final BodyBuildingExercise exercise;

  BodyBuildingExerciseReadingScreen(this.exercise);

  Widget _buildDescriptionTab() {
    return exercise.richDescription != null
        ? ListView(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Html(
                    data: exercise.richDescription,
                    useRichText: true,
                    showImages: true,
                  ))
            ],
          )
        : Center(
            child: Text(
              Texts.itemExerciseNoRichDescription,
            ),
          );
  }

  Widget _buildPictureTab() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: exercise.pictureImageReference != null
            ? networkImage(
                exercise.pictureImageReference.toFullUrl(),
              )
            : Text(
                Texts.itemExerciseNoPicture,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(exercise.title),
          elevation: 0.0,
          backgroundColor: Constants.colorAccent,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.short_text)),
              Tab(icon: Icon(Icons.photo_size_select_actual)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDescriptionTab(),
            _buildPictureTab(),
          ],
        ),
      ),
    );
  }

  static Future<MaterialPageRoute> open(BuildContext context, BodyBuildingExercise exercise) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BodyBuildingExerciseReadingScreen(exercise),
      ),
    );
  }
}

class BodyBuildingExerciseEvolutionScreen extends StatefulWidget {
  final List<BodyBuildingExercise> _exercises;

  const BodyBuildingExerciseEvolutionScreen(List<BodyBuildingExercise> exercises, {Key key})
      : assert(exercises != null),
        this._exercises = exercises,
        super(key: key);

  @override
  State<BodyBuildingExerciseEvolutionScreen> createState() {
    return BodyBuildingExerciseEvolutionScreenState(_exercises);
  }

  static void open(BuildContext context, List<BodyBuildingExercise> exercises) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return BodyBuildingExerciseEvolutionScreen(exercises);
    }));
  }
}

/********************************************************************************** */
class TimeSeriesRangeAnnotationChart extends StatelessWidget {
  final List<charts.Series> seriesList;

  TimeSeriesRangeAnnotationChart(this.seriesList);

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: true,
      primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec: new charts.BasicNumericTickProviderSpec(
          desiredTickCount: 5,
          desiredMaxTickCount: 20,
        ),
      ),
      behaviors: [
        charts.PanAndZoomBehavior(),
      ],
    );
  }

  factory TimeSeriesRangeAnnotationChart.filterWithType(List<BodyBuildingExerciseValueHolder> holders, BodyBuildingExerciseValueHolderType currentValueHolderType) {
    final List<BodyBuildingExerciseValueHolder> data = holders.where((holder) => holder.type == currentValueHolderType).toList();

    return new TimeSeriesRangeAnnotationChart(
      <charts.Series<BodyBuildingExerciseValueHolder, DateTime>>[
        new charts.Series<BodyBuildingExerciseValueHolder, DateTime>(
          id: Texts.valueHolderTypeTranslations[currentValueHolderType],
          domainFn: (BodyBuildingExerciseValueHolder holder, _) => holder.date,
          measureFn: (BodyBuildingExerciseValueHolder holder, _) => holder.value,
          data: data,
        )
      ],
    );
  }
}

class BodyBuildingExerciseEvolutionScreenState extends State<BodyBuildingExerciseEvolutionScreen> {
  final List<BodyBuildingExercise> _exercises;
  double _graphHeight;
  Map<BodyBuildingExercise, List<BodyBuildingExerciseValueHolder>> _holders;

  List<DropdownMenuItem<BodyBuildingExerciseValueHolderType>> _dropDownMenuItems;
  BodyBuildingExerciseValueHolderType _currentValueHolderType;

  BodyBuildingExerciseEvolutionScreenState(List<BodyBuildingExercise> exercises)
      : assert(exercises != null),
        this._exercises = exercises;

  @override
  void initState() {
    super.initState();

    _holders = new Map();

    _dropDownMenuItems = getDropDownMenuItems();
    _currentValueHolderType = _dropDownMenuItems[0].value;
  }

  List<DropdownMenuItem<BodyBuildingExerciseValueHolderType>> getDropDownMenuItems() {
    List<DropdownMenuItem<BodyBuildingExerciseValueHolderType>> items = new List();

    BodyBuildingExerciseValueHolderType.values.forEach((type) {
      items.add(new DropdownMenuItem(
        value: type,
        child: new Text(
          Texts.valueHolderTypeTranslations[type].toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ));
    });

    return items;
  }

  Widget _buildBottomBar(BuildContext context) {
    return BottomAppBar(
      color: Constants.colorAccent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: new Theme(
                data: Theme.of(context).copyWith(canvasColor: Constants.colorAccent),
                child: DropdownButtonHideUnderline(
                  child: new DropdownButton<BodyBuildingExerciseValueHolderType>(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    value: _currentValueHolderType,
                    items: _dropDownMenuItems,
                    onChanged: (valueHolderType) {
                      setState(() {
                        _currentValueHolderType = valueHolderType;
                      });
                    },
                    iconEnabledColor: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingBox(BuildContext context) {
    return Container(
      height: _graphHeight,
      width: double.infinity,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildGraph(BuildContext context, BodyBuildingExercise exercise) {
    List<BodyBuildingExerciseValueHolder> holders = _holders[exercise];

    return Container(
      height: _graphHeight,
      width: double.infinity,
      child: Builder(
        builder: (context) {
          if (holders.isNotEmpty) {
            return TimeSeriesRangeAnnotationChart.filterWithType(holders, _currentValueHolderType);
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InfoCard.templateNoContent(),
            ],
          );
        },
      ),
    );
  }

  String get screenTitle {
    String base = "Evolution";

    if (_exercises.length > 1) {
      base += " de ${_exercises.length} exercices";
    }

    return base;
  }

  Widget _buildTile(BuildContext context, int index) {
    BodyBuildingExercise exercise = _exercises[index];
    bool hasValue = _holders.containsKey(exercise);

    if (!hasValue) {
      Managers.bodyBuildingManager.resolveEvolutionData(exercise.md5).then((data) {
        setState(() {
          _holders[exercise] = data;
        });
      });
    }

    return GestureDetector(
      onTap: () => BodyBuildingExerciseReadingScreen.open(context, exercise),
      child: Card(
        elevation: 0.0,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                exercise.title,
                style: Theme.of(context).textTheme.title,
                textAlign: TextAlign.center,
              ),
            ),
            CommonDivider(),
            Builder(
              builder: (context) {
                return hasValue ? _buildGraph(context, exercise) : _buildLoadingBox(context);
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _graphHeight = MediaQuery.of(context).size.height / 3;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(screenTitle),
        backgroundColor: Constants.colorAccent,
      ),
      bottomNavigationBar: _buildBottomBar(context),
      body: ListView.builder(
        itemCount: _exercises.length,
        itemBuilder: _buildTile,
      ),
    );
  }
}
