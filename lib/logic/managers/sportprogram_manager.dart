import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/models/sportprogram.dart';
import 'package:mon_guide_musculation/ui/pages/page_sportprogram.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:mon_guide_musculation/utils/wix_utils.dart';

import '../../main.dart';

class SportProgramManager extends BaseManager {
  SportProgram cachedProgram;
  List<SportProgram> savedPrograms;
  bool _dialogCurrentlyOpen = false;

  @override
  void initialize() {}

  Future<void> fetchByToken(String token, {bool acceptCache = false}) async {
    assert(token != null);

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

  Future<void> retriveSaved() {
    return Future(() {
      
    });
  }

  void onReceivedToken(String token) {
    if (_dialogCurrentlyOpen) {
      Navigator.of(MyApp.staticContext).pop();
    }

    showDialog(
      context: MyApp.staticContext,
      builder: (BuildContext context) {
        _dialogCurrentlyOpen = true;
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Ajouter un programme",
            style: const TextStyle(
              color: Constants.colorAccent,
            ),
            textAlign: TextAlign.center,
          ),
          elevation: 0.0,
          contentPadding: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
          content: SportProgramImportScreen(token),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new RaisedButton(
              child: new Text(
                "AJOUTER",
                style: const TextStyle(color: Colors.white),
              ),
              elevation: 0.0,
              color: Constants.colorAccent,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((results) {
      print("closed");
      print(results);
      _dialogCurrentlyOpen = false;
    });
  }
}
