import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/models/bodybuilding.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/models/sportprogram.dart';
import 'package:mon_guide_musculation/pages/home_page.dart';
import 'package:mon_guide_musculation/ui/pages/page_sportprogram.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:mon_guide_musculation/utils/functions.dart';
import 'package:mon_guide_musculation/utils/wix_utils.dart';

import '../../main.dart';

class SportProgramManager extends BaseManager {
  static const String columnId = "_id";
  static const String columnDate = "exercise";
  static const String columnType = "type";
  static const String columnValue = "value";

  bool _dialogCurrentlyOpen = false;
  File _storageFile;
  Database _evolutionDatabase;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  SportProgram cachedProgram;
  List<SportProgram> savedPrograms;

  @override
  void initialize() async {
    _storageFile = await getLocalFile(AppStorage.sportProgramDataFile);
    _initializeDatabase();

    [_storageFile].forEach((file) => file.createSync(recursive: true));

    savedPrograms = new List();
  }

  void _initializeDatabase() async {
    _evolutionDatabase = await openDatabase(
      join(await getDatabasesPath(), AppStorage.sportProgramEvolutionDatabaseFile),
      version: 1,
    );
  }

  void notifyBodyBuildingExerciseReceived(List<BodyBuildingExercise> received) {
    received.forEach((program) {
      String md5Key = toMd5(program.key);
      print("Trying to create evolution table: $md5Key (original key is \"${program.key}\")");

      _evolutionDatabase.execute(
        "" + //
            "CREATE TABLE IF NOT EXISTS `$md5Key` (" + //
            "    `$columnId` INTEGER PRIMARY KEY AUTOINCREMENT," + //
            "    `$columnDate` DATE NOT NULL," + //
            "    `$columnType` VARCHAR(64) NOT NULL," + //
            "    `$columnValue` INT(11) NOT NULL" + //
            ");", //
      );
    });
  }

  Future<SportProgram> fetchByToken(String token, {bool acceptCache = false}) async {
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
        .then((jsonPayload) => _createSportProgram(jsonPayload))
        .then((program) => cachedProgram = program);
  }

  Future<SportProgram> _createSportProgram(Map<String, dynamic> data) async {
    List<SportProgramItem> items = new List();

    print(data);

    SportProgram program = SportProgram.fromJson(data["program"], items);

    for (dynamic item in (data["exercises"] as List<dynamic>)) {
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
  }

  Future<List<SportProgram>> retriveSaved() {
    return _retriveFileContent().then((data) {
      List<dynamic> items = data[AppStorage.sportProgramJsonItemsKey];

      if (items != null) {
        return items;
      }

      return [];
    }).then((items) async {
      savedPrograms.clear();

      for (Map<String, dynamic> item in items) {
        savedPrograms.add(await _createSportProgram(item));
      }
    }).then((_) => savedPrograms);
  }

  Future<void> _import(String token) async {
    assert(token != null);

    if (cachedProgram == null) {
      HomePage.showSnackBar(SnackBar(
        content: Text(Texts.snackBarErrorNotFullyLoaded),
        action: SnackBarAction(
          label: Texts.snackBarButtonClose,
          onPressed: () {},
        ),
      ));
      return null;
    }

    List<dynamic> newData = await retriveSaved().then((programs) {
      SportProgram sportProgram = getWithProcessing(programs, (item) => cachedProgram.id == item.id);

      if (sportProgram == null) {
        programs.insert(0, cachedProgram);
      } else {
        programs.remove(sportProgram);
        programs.insert(0, cachedProgram);
      }

      return programs;
    }).then((programs) => _transformSportProgramListToJson(programs));

    return _pushFileContent(AppStorage.sportProgramJsonItemsKey, newData).then((_) => _sendContentUpdate());
  }

  List<dynamic> _transformSportProgramListToJson(List<SportProgram> programs) {
    List<dynamic> sources = new List();
    programs.forEach((program) => sources.add(program.toOriginalJson()));
    return sources;
  }

  void remove(SportProgram sportProgram) async {
    await retriveSaved().then((programs) {
      programs.removeWhere((item) => item.token == sportProgram.token);
      return programs;
    }).then((programs) => _savePrograms(programs));
  }

  void _savePrograms(List<SportProgram> programs) async {
    List<dynamic> newData = _transformSportProgramListToJson(programs);

    return _pushFileContent(AppStorage.sportProgramJsonItemsKey, newData).then((_) => _sendContentUpdate());
  }

  Future<Map<String, dynamic>> _retriveFileContent() {
    return _storageFile.readAsString().then((content) => content != "" ? json.decode(content) : new Map());
  }

  Future<void> _pushFileContent(String key, dynamic content) {
    return _retriveFileContent().then((data) {
      data[key] = content;
      return json.encode(data);
    }).then((data) {
      _storageFile.writeAsStringSync(data);
      print("Writing... => " + data);
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

        return AlertDialog(
          title: new Text(
            Texts.dialogTitleImportSportProgram,
            style: const TextStyle(
              color: Constants.colorAccent,
            ),
            textAlign: TextAlign.center,
          ),
          elevation: 0.0,
          contentPadding: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
          content: SportProgramImportScreen(token),
          actions: <Widget>[
            new RaisedButton(
              child: new Text(
                Texts.buttonImport,
                style: const TextStyle(color: Colors.white),
              ),
              elevation: 0.0,
              color: Constants.colorAccent,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ).then((results) {
      _dialogCurrentlyOpen = false;

      Object response = results;
      if (response == null) {
        return null;
      }

      if (response as bool) {
        _import(token);
      }
    });
  }

  void useRefreshIndicatorKey(GlobalKey<RefreshIndicatorState> refreshIndicatorKey) {
    this._refreshIndicatorKey = refreshIndicatorKey;
  }

  void _sendContentUpdate() {
    if (this._refreshIndicatorKey == null || this._refreshIndicatorKey.currentState == null) {
      return;
    }

    print("Sending content update.");

    this._refreshIndicatorKey.currentState.show();
  }

  bool rename(SportProgram sportProgram, String newName) {
    if (sportProgram.rename(newName)) {
      _savePrograms(savedPrograms);

      return true;
    }

    return false;
  }
}
