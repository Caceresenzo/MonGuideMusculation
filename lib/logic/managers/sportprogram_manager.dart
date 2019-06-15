import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/models/bodybuilding.dart';
import 'package:mon_guide_musculation/models/sportprogram.dart';
import 'package:mon_guide_musculation/utils/wix_utils.dart';

class SportProgramManager extends BaseManager {
  SportProgram cachedProgram;

  @override
  void initialize() {}

  Future<void> fetchByToken(String token, {bool acceptCache = false}) async {
    cachedProgram = null;

    print(token);

    return http
        .get(WixUtils.formatSportProgramUrlByToken(token))
        .then((response) {
          return response.statusCode == 200 ? response.body : throw 'Error when getting data';
        })
        .then((body) => json.decode(body))
        .then((data) => data["error"] == null ? data["payload"] : throw Exception(data["error"]))
        .then((jsonPayload) async {
          List<SportProgramItem> items = new List();

          print(jsonPayload);

          SportProgram program = SportProgram.fromJson(jsonPayload["program"], items);

          for (dynamic item in (jsonPayload["exercises"] as List<dynamic>)) {
            try {
              items.add(SportProgramItem.fromJson(
                item,
                program,
                await Managers.bodyBuildingManager.resolveExerciseByKey(item["exercise"]["key"]),
              ));
            } catch (error) {
              print("Invalid entry with redactor id: ${item["redactor_id"]}");
              print(error);
            }
          }

          return program;
        })
        .then((program) => cachedProgram = program);
  }
}
