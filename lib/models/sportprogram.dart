import 'package:meta/meta.dart';
import 'package:mon_guide_musculation/models/bodybuilding.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:mon_guide_musculation/utils/functions.dart';
import 'package:random_string/random_string.dart';

class SportProgram {
  final String id;
  final String createdDate;
  final String token;
  final String target;
  final List<SportProgramItem> items;
  final bool _isCustom;
  String _name;

  SportProgram({
    this.id,
    this.createdDate,
    this.token,
    this.target,
    this.items,
    String name,
    bool isCustom = false,
  })  : assert(id != null),
        assert(token != null),
        assert(items != null),
        this._name = name,
        this._isCustom = (isCustom ?? false);

  bool get isCustom => _isCustom;

  String name() {
    if (_name == null || _name.isEmpty) {
      return Texts.defaultSportProgramName;
    }

    return _name;
  }

  factory SportProgram.fromJson(Map<String, dynamic> data, List<SportProgramItem> items, {String name, bool isCustom}) {
    assert(data != null);

    return new SportProgram(
      id: data["_id"],
      createdDate: data["created_date"],
      token: data["token"],
      target: data["target"],
      items: items,
      name: data["name"],
      isCustom: isCustom ?? data["isCustom"],
    );
  }

  factory SportProgram.empty() {
    return new SportProgram(
      id: "",
      createdDate: new DateTime.now().toString(),
      token: "CUSTOM-" + randomAlphaNumeric(50),
      items: <SportProgramItem>[],
      isCustom: true,
    );
  }

  Map<String, dynamic> toOriginalJson() {
    print({
      "program": {
        "_id": id,
        "created_date": createdDate,
        "token": token,
        "target": isCustom ? null : target,
        "name": name(),
      },
      "exercises": List.generate(items.length, (index) => items[index].toOriginalJson())
    });

    return {
      "program": {
        "_id": id,
        "created_date": createdDate,
        "token": token,
        "target": isCustom ? null : target,
        "name": name(),
        "isCustom": isCustom,
      },
      "exercises": List.generate(items.length, (index) => items[index].toOriginalJson())
    };
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

  num get safeWeight => safeNumber(weight);

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

  toOriginalJson() {
    return {
      "exercise": {"key": exercise.key},
      "series": series,
      "repetitions": repetitions,
      "weight": weight,
      "redactor_id": redactorId,
    };
  }
}
