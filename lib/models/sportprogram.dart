import 'package:meta/meta.dart';
import 'package:mon_guide_musculation/models/bodybuilding.dart';
import 'package:mon_guide_musculation/utils/constants.dart';

class SportProgram {
  final Map<String, dynamic> source;
  final String id;
  final String createdDate;
  final String token;
  final String target;
  final List<SportProgramItem> items;
  String _name;

  SportProgram({
    this.source,
    this.id,
    this.createdDate,
    this.token,
    this.target,
    this.items,
    String name,
  })  : assert(id != null),
        assert(token != null),
        assert(target != null),
        assert(items != null),
        this._name = name;

  String name() {
    if (_name == null || _name.isEmpty) {
      return Texts.defaultSportProgramName;
    }

    return _name;
  }

  factory SportProgram.fromJson(Map<String, dynamic> data, List<SportProgramItem> items, {String name}) {
    assert(data != null);

    if (name == null) {
      name = data["name"];
    }
    data["name"] = name != null ? name : Texts.defaultSportProgramName;

    return new SportProgram(
      source: data,
      id: data["_id"],
      createdDate: data["created_date"],
      token: data["token"],
      target: data["target"],
      items: items,
      name: data["name"],
    );
  }

  Map<String, dynamic> toOriginalJson() {
    Map<String, dynamic> data = new Map();

    data["program"] = source;
    data["exercises"] = List.generate(items.length, (index) => items[index].source);

    return data;
  }

  bool rename(String newName) {
    if (newName == null || newName.isEmpty) {
      if (Constants.sportProgramRenameBackToDefaultIfInvalid) {
        newName = Texts.defaultSportProgramName;
      } else {
        return false;
      }
    }

    if (newName == this._name) {
      return false;
    }

    this._name = newName;
    this.source["name"] = newName;

    return true;
  }

  List<BodyBuildingExercise> toExerciseList() {
    List<BodyBuildingExercise> exercises = new List();
    items.forEach((item) => exercises.add(item.exercise));
    return exercises;
  }
}

@immutable
class SportProgramItem {
  final Map<String, dynamic> source;
  final SportProgram parent;
  final BodyBuildingExercise exercise;
  final int series;
  final int repetitions;
  final double weight;
  final String redactorId;

  SportProgramItem({
    this.source,
    this.parent,
    this.exercise,
    this.series,
    this.repetitions,
    this.weight,
    this.redactorId,
  })  : assert(parent != null),
        assert(series != null),
        assert(repetitions != null),
        assert(weight != null);

  factory SportProgramItem.fromJson(Map<String, dynamic> data, SportProgram parent, BodyBuildingExercise exercise) {
    return new SportProgramItem(
      source: data,
      parent: parent,
      exercise: exercise,
      series: int.parse(data["series"].toString()),
      repetitions: int.parse(data["repetitions"].toString()),
      weight: double.parse(data["weight"].toString()),
      redactorId: data["redactor_id"],
    );
  }

  num get safeWeight {
    int intValue = weight.toInt();

    if (intValue == weight) {
      return intValue;
    }

    return weight;
  }

  getValueByType(BodyBuildingExerciseValueHolderType type) {
    switch (type) {
      case BodyBuildingExerciseValueHolderType.series:
        return series;
      case BodyBuildingExerciseValueHolderType.repetitions:
        return repetitions;
      case BodyBuildingExerciseValueHolderType.weight:
        return weight;
      default:
        throw Exception("Illegal enum value.");
    }
  }
}
