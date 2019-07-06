import 'dart:convert';

import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/models/bodybuilding.dart';
import 'package:http/http.dart' as http;
import 'package:mon_guide_musculation/models/sportprogram.dart';
import 'package:mon_guide_musculation/utils/functions.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mon_guide_musculation/utils/constants.dart';

class BodyBuildingManager extends BaseManager {
  static const String columnId = "_id";
  static const String columnDate = "exercise";
  static const String columnType = "type";
  static const String columnValue = "value";

  bool _cacheIsValid = false;
  Database _evolutionDatabase;

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

    _initializeDatabase();
  }

  void _initializeDatabase() async {
    _evolutionDatabase = await openDatabase(
      join(await getDatabasesPath(), AppStorage.sportProgramEvolutionDatabaseFile),
      version: 1,
    );
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

  void _clearCache() {
    [cachedExercices, cachedExerciceTypes, cachedMuscles].forEach((list) => list.clear());
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
          _clearCache();

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
          int alphabetical(a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase());

          cachedMuscles.sort(alphabetical);
          cachedExercices.sort(alphabetical);

          cachedMuscles.forEach((muscle) => muscle.exercises.sort(alphabetical));
          cachedExerciceTypes.forEach((exerciseType) => exerciseType.exercises.sort(alphabetical));

          _cacheIsValid = true;
        })
        .then((_) {
          notifyBodyBuildingExerciseReceived(cachedExercices);
        })
        .catchError((error) {
          _clearCache();
        });
  }

  void notifyBodyBuildingExerciseReceived(List<BodyBuildingExercise> received) async {
    for (BodyBuildingExercise program in received) {
      String md5Key = program.md5;
      print("Trying to create evolution table: $md5Key (original key is \"${program.key}\")");

       _evolutionDatabase.execute(
        "" + //
            "DROP TABLE `$md5Key`", //
      );

      await _evolutionDatabase.execute(
        "" + //
            "CREATE TABLE IF NOT EXISTS `$md5Key` (" + //
            "    `$columnId` INTEGER PRIMARY KEY AUTOINCREMENT," + //
            "    `$columnDate` DATE NOT NULL," + //
            "    `$columnType` INTEGER NOT NULL," + //
            "    `$columnValue` DOUBLE NOT NULL" + //
            ");", //
      );
    }

    _evolutionDatabase.rawQuery("SELECT sql FROM sqlite_master;").then((value) {
      value.forEach((a) {
        print(a);
      });
    });
  }

  void notifySportProgramFinished(SportProgram sportProgram) async {
    print("Finished sport program with token ${sportProgram.token} (named \"${sportProgram.name()}\")");

    Batch batch = _evolutionDatabase.batch();

    for (SportProgramItem item in sportProgram.items) {
      var exercise = item.exercise;
      DateTime dateTime = DateTime.now();

      for (BodyBuildingExerciseValueHolderType type in BodyBuildingExerciseValueHolderType.values) {
        batch.insert("`${exercise.md5}`", {
          columnDate: dateTime.millisecondsSinceEpoch,
          columnType: type.index,
          columnValue: item.getValueByType(type),
        });
      }
    }

    await batch.commit().then((results) {
      print("Insert ids: " + results.toString());
    });
  }

  Future<List<BodyBuildingExerciseValueHolder>> resolveEvolutionData(String md5) async {
    List<BodyBuildingExerciseValueHolder> data = new List();

    await _evolutionDatabase.query("`$md5`").then((results) async {
      for (Map<String, dynamic> result in results) {
        data.add(await BodyBuildingExerciseValueHolder.fromSqlEntry(result));
        print(result);
      }
    });

    return data;
  }
}
