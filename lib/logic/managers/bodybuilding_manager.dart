import 'dart:convert';

import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/models/bodybuilding.dart';
import 'package:mon_guide_musculation/models/forum.dart';
import 'package:http/http.dart' as http;
import 'package:mon_guide_musculation/utils/constants.dart';

class BodyBuildingManager extends BaseManager {
  List<BodyBuildingExercise> cachedExercices;
  List<BodyBuildingExerciseType> cachedExerciceTypes;
  List<BodyBuildingMuscle> cachedMuscles;

  List<List> cachedLists;

  @override
  void initialize() {
    cachedExercices = new List();
    cachedExerciceTypes = new List();
    cachedMuscles = new List();

    cachedLists = [cachedExercices, cachedExercices, cachedExercices];
  }

  Future<void> fetch(bool acceptCache) async {
    return http
        .get(WixUrls.backendGetExercices)
        .then((response) {
          return response.statusCode == 200 ? response.body : throw 'Error when getting data';
        })
        .then((body) => json.decode(body))
        .then((data) => data["error"] == null ? data["payload"] : throw Exception(data["error"]))
        .then((jsonPayload) {
          [cachedExercices, cachedExerciceTypes, cachedMuscles].forEach((list) => list.clear());

          Map<String, BodyBuildingExerciseType> typesMap = new Map();
          Map<String, BodyBuildingMuscle> musclesMap = new Map();

          (jsonPayload["exercises"]["types"] as Map<String, dynamic>).forEach((key, value) {
            BodyBuildingExerciseType exerciseType = BodyBuildingExerciseType.fromJson(value);

            typesMap[exerciseType.key] = exerciseType;
            cachedExerciceTypes.add(exerciseType);
          });

          (jsonPayload["muscles"] as Map<String, dynamic>).forEach((key, value) {
            BodyBuildingMuscle muscle = BodyBuildingMuscle.fromJson(value);

            musclesMap[muscle.key] = muscle;
            cachedMuscles.add(muscle);
          });

          (jsonPayload["exercises"]["list"] as Map<String, dynamic>).forEach((key, value) {
            BodyBuildingExerciseType exersiseType = typesMap[value["type"]];
            BodyBuildingMuscle muscle = musclesMap[value["muscle"]];

            cachedExercices.add(BodyBuildingExercise.fromJson(value, exersiseType, muscle));
          });
        })
        .then((_) {
          cachedMuscles.sort((a, b) {
            return a.title.toLowerCase().compareTo(b.title.toLowerCase());
          });
        });
  }
}
