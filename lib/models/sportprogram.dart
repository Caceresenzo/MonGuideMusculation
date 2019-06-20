import 'package:meta/meta.dart';
import 'package:mon_guide_musculation/models/bodybuilding.dart';
import 'package:mon_guide_musculation/utils/constants.dart';

@immutable
class SportProgram {
  final Map<String, dynamic> source;
  final String id;
  final String createdDate;
  final String token;
  final String target;
  final List<SportProgramItem> items;
  String name;

  SportProgram({
    this.source,
    this.id,
    this.createdDate,
    this.token,
    this.target,
    this.items,
    this.name,
  })  : assert(id != null),
        assert(token != null),
        assert(target != null),
        assert(items != null);

  factory SportProgram.fromJson(Map<String, dynamic> data, List<SportProgramItem> items, {String name}) {
    assert(data != null);

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
}

@immutable
class SportProgramItem {
  final Map<String, dynamic> source;
  final SportProgram parent;
  final BodyBuildingExercise exercise;
  final int series;
  final int repetitions;
  final int weight;
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
        assert(exercise != null),
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
      weight: int.parse(data["weight"].toString()),
      redactorId: data["redactor_id"],
    );
  }
}

enum SportProgramEvolutionType {
  SERIES,
  REPETITIONS,
  WEIGHT,
}
