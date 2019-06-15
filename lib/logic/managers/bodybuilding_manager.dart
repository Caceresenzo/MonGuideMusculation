import 'dart:convert';

import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/models/bodybuilding.dart';
import 'package:http/http.dart' as http;
import 'package:mon_guide_musculation/utils/constants.dart';

class BodyBuildingManager extends BaseManager {
  bool _cacheIsValid = false;

  List<BodyBuildingExercise> cachedExercices;
  List<BodyBuildingExerciseType> cachedExerciceTypes;
  List<BodyBuildingMuscle> cachedMuscles;
  int invalidEntryCount;

  @override
  void initialize() {
    cachedExercices = new List();
    cachedExerciceTypes = new List();
    cachedMuscles = new List();

    invalidEntryCount = 0;
  }

  Future<BodyBuildingExercise> resolveExerciseByKey(String key, {bool acceptCache = true}) async {
    return fetch(acceptCache).then((_) {
      for (BodyBuildingExercise exercise in cachedExercices) {
        if (exercise.key == key) {
          return exercise;
        }
      }

      return null;
    });
  }

  Future<void> fetch(bool acceptCache) async {
    if (acceptCache && _cacheIsValid) {
      return null;
    }

    _cacheIsValid = false;

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

          invalidEntryCount = 0;
          (jsonPayload["exercises"]["list"] as Map<String, dynamic>).forEach((key, value) {
            BodyBuildingExerciseType exersiseType = typesMap[value["type"]];
            BodyBuildingMuscle muscle = musclesMap[value["muscle"]];

            try {
              cachedExercices.add(BodyBuildingExercise.fromJson(value, exersiseType, muscle));
            } catch (error) {
              invalidEntryCount++;
              print("Invalid entry: ${value["title"]}");
              print(error);
            }
          });
          print("Invalid entry count: $invalidEntryCount");
        })
        .then((_) {
          cachedMuscles.sort((a, b) {
            return a.title.toLowerCase().compareTo(b.title.toLowerCase());
          });

          _cacheIsValid = true;
        });
  }
}
