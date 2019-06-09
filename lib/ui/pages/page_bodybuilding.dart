import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/models/bodybuilding.dart';
import 'package:mon_guide_musculation/models/forum.dart';
import 'package:mon_guide_musculation/ui/states/common_refreshable_state.dart';
import 'package:mon_guide_musculation/ui/widgets/card_info.dart';
import 'package:mon_guide_musculation/ui/widgets/circular_user_avatar.dart';
import 'package:mon_guide_musculation/ui/widgets/common_divider.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:mon_guide_musculation/utils/functions.dart';
import 'package:mon_guide_musculation/utils/wix_utils.dart';

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
        subtitle: Text(exercise.shortDescription ?? Texts.itemMuscleNoShortDescription),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {},
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
  Widget buildItem(BuildContext context, List<BodyBuildingMuscle> items, int index) {
    return SizedBox(
      child: BodyBuildingMuscleWidget(items[index]),
    );
  }

  @override
  Widget buildAppBar(BuildContext context) => null;
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
          type == null ? "Tous les exercices".toUpperCase() : ("Exercice " + type.title).toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ));
    });

    return items;
  }

  @override
  Widget build(BuildContext context) {
    print("building: " + items.length.toString());

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
