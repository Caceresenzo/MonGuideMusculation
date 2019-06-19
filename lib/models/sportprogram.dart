import 'package:meta/meta.dart';
import 'package:mon_guide_musculation/models/bodybuilding.dart';

@immutable
class SportProgram {
  final String id;
  final String createdDate;
  final String token;
  final String target;
  final List<SportProgramItem> items;

  SportProgram({
    this.id,
    this.createdDate,
    this.token,
    this.target,
    this.items,
  })  : assert(id != null),
        assert(token != null),
        assert(target != null),
        assert(items != null);

  factory SportProgram.fromJson(Map<String, dynamic> data, List<SportProgramItem> items) {
    return new SportProgram(
      id: data["_id"],
      createdDate: data["created_date"],
      token: data["token"],
      target: data["target"],
      items: items,
    );
  }
}

@immutable
class SportProgramItem {
  final SportProgram parent;
  final BodyBuildingExercise exercise;
  final int series;
  final int repetitions;
  final int weight;
  final String redactorId;

  SportProgramItem({
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
      parent: parent,
      exercise: exercise,
      series: data["series"],
      repetitions: data["repetitions"],
      weight: data["weight"],
      redactorId: data["redactor_id"],
    );
  }
}
