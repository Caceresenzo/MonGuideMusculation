import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/models/wix.dart';

class BodyBuildingExercise {
  final String key;
  final String title;
  final BodyBuildingExerciseType type;
  final BodyBuildingMuscle muscle;
  final String shortDescription;
  final String richDescription;
  final WixImageReference pictureImageReference;

  BodyBuildingExercise({
    @required this.key,
    @required this.title,
    @required this.type,
    @required this.muscle,
    @required this.shortDescription,
    @required this.richDescription,
    @required this.pictureImageReference,
  })  : assert(key != null),
        assert(title != null),
        assert(type != null),
        assert(muscle != null);

  BodyBuildingExercise finishConstruction() {
    type.exercises.add(this);
    muscle.exercises.add(this);

    return this;
  }

  factory BodyBuildingExercise.fromJson(Map<String, dynamic> data, BodyBuildingExerciseType exersiseType, BodyBuildingMuscle muscle) {
    return BodyBuildingExercise(
      key: data["key"],
      title: data["title"],
      type: exersiseType,
      muscle: muscle,
      shortDescription: data["short_description"],
      richDescription: data["rich_description"] != null ? data["rich_description"].replaceAll("&nbsp;", " ") : null,
      pictureImageReference: WixImageReference.safe(data["picture"]),
    ).finishConstruction();
  }
}

@immutable
class BodyBuildingExerciseType {
  final String key;
  final String title;
  final List<BodyBuildingExercise> exercises = new List();

  BodyBuildingExerciseType({
    @required this.key,
    @required this.title,
  })  : assert(key != null),
        assert(title != null);

  factory BodyBuildingExerciseType.fromJson(Map<String, dynamic> data) {
    return BodyBuildingExerciseType(
      key: data["key"],
      title: data["title"],
    );
  }
}

class BodyBuildingMuscle {
  final String key;
  final String title;
  final WixImageReference iconImageReference;
  final List<BodyBuildingExercise> exercises = new List();

  BodyBuildingMuscle({
    @required this.key,
    @required this.title,
    @required this.iconImageReference,
  })  : assert(key != null),
        assert(title != null);

  factory BodyBuildingMuscle.fromJson(Map<String, dynamic> data) {
    return BodyBuildingMuscle(
      key: data["key"],
      title: data["title"],
      iconImageReference: WixImageReference.safe(data["icon"]),
    );
  }
}
