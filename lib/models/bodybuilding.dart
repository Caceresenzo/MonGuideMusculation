import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/logic/managers/bodybuilding_manager.dart';
import 'package:mon_guide_musculation/models/wix.dart';
import 'package:mon_guide_musculation/utils/functions.dart';

class BodyBuildingExercise {
  final String key;
  final String title;
  final BodyBuildingExerciseType type;
  final BodyBuildingMuscle muscle;
  final String shortDescription;
  final String richDescription;
  final WixImageReference pictureImageReference;
  final String md5;

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
        assert(muscle != null),
        this.md5 = toMd5(key);

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

@immutable
class BodyBuildingExerciseValueHolder {
  final int _id;
  final DateTime _date;
  final BodyBuildingExerciseValueHolderType _type;
  final double _value;

  BodyBuildingExerciseValueHolder(
    int id,
    DateTime date,
    BodyBuildingExerciseValueHolderType type,
    double value,
  )   : assert(id != null),
        assert(date != null),
        assert(type != null),
        assert(value != null),
        this._id = id,
        this._date = date,
        this._type = type,
        this._value = value;

  int get id => _id;
  DateTime get date => _date;
  BodyBuildingExerciseValueHolderType get type => _type;
  double get value => _value;

  static Future<BodyBuildingExerciseValueHolder> fromSqlEntry(Map<String, dynamic> result) async {
    return BodyBuildingExerciseValueHolder(
      result[BodyBuildingManager.columnId],
      DateTime.fromMillisecondsSinceEpoch(result[BodyBuildingManager.columnDate]),
      BodyBuildingExerciseValueHolderType.values[result[BodyBuildingManager.columnType]],
      num.parse(result[BodyBuildingManager.columnValue].toString()),
    );
  }
}

enum BodyBuildingExerciseValueHolderType { series, repetitions, weight }
