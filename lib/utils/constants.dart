import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/models/bodybuilding.dart';
import 'package:mon_guide_musculation/models/sportprogram.dart';
import 'package:date_format/date_format.dart';

class Constants {
  static const bool debug = false;

  static const int colorAccentHex = 0xFFEF6C00;
  static const Color colorAccent = const Color(colorAccentHex);
  static const Color colorCodeblock = const Color(0xFFF2F2F2);

  static const Size resizeBodyBuildingMuscleImage = const Size(500, 500);

  static const String customScheme = "mgm";

  static const bool sportProgramRenameBackToDefaultIfInvalid = true;

  static const Size articleImageApiResize = Size(5000, 500);
}

class Texts {
  static const String applicationName = "Mon Guide Musculation";
  static const String applicationVersion = "BETA 0.0.1";
  static const String applicationDeveloper = "par Enzo CACERES";

  static const String navigationSportProgram = "Progrms";
  static const String navigationBodyBuilding = "Muscu";
  static const String navigationArticles = "Articles";
  static const String navigationForum = "Forum";
  static const String navigationContact = "Contact";

  static const String contactCoatching = "COATCHING";
  static const String contactSocialNetworks = "RÉSEAUX SOCIAUX";
  static const String ruisiFullName = "Mahé RUISI";
  static const String ruisiAddress = "Bourges\nFrance";
  static const String ruisiBackgroundContactImageUrl = "https://static.wixstatic.com/media/1bf8c6_896e6f814a7644fd93a44de8db1d8791~mv2_d_1957_2081_s_2.jpg";

  static const String screenMuscleList = "Liste des Muscles";
  static const String screenEvolution = "Evolution";
  static const String screenSportProgramCreator = "Crée un programme";
  static const String screenSportProgramCreatorAddExercise = "Ajouter un Exercice";

  static const String pageNoContent = "Rien à dire frère";
  static const String pageNoContentSub = "(aucun contenu disponible)";
  static const String pageNoAnswer = "C'est la sèche ici";
  static const String pageNoAnswerSub = "(aucune réponse)";
  static const String pageFailedToLoad = "J'ai pas réussi...";
  static const String pageFailedToLoadSub = "(chargement échoué)";
  static const String pageEmpty = "Y'a rien a voir.";
  static const String pageEmptySub = "(contenu vide)";

  static const String itemSportProgramNumberSeries = " séries";
  static const String itemSportProgramOfRepetitions = "de";
  static const String itemSportProgramNumberRepetitions = " répétitions";
  static const String itemSportProgramAtWeight = "à";
  static const String itemSportProgramNumberWeight = " kg";
  static const String itemMuscleNoShortDescription = "Aucune courte description.";
  static const String itemExerciseNoRichDescription = "Aucune description.";
  static const String itemExerciseNoPicture = "Aucune image de démonstration.";

  static const String sportProgramScreenButtonEvolution = "ÉVOLUTION";
  static const String sportProgramScreenButtonStart = "DÉMARRER";
  static const String sportProgramScreenButtonEdit = "ÉDITER";
  static const String sportProgramRenamed = "Programme renommé.";
  static const String sportProgramNotRenamed = "Programme non renommé.";
  static const String sportProgramObjectives = "OBJECTIFS";
  static const String sportProgramButtonNextItem = "Suivant";
  static const String sportProgramButtonPreviousItem = "Précédent";
  static const String sportProgramSnackBarQuit = "Voulez vous quitter ?";
  static const String sportProgramSnackBarFinish = "Avez vous fini ?";
  static const String sportProgramSnackBarButtonYes = "OUI";
  static const String sportProgramDialogWantToSeeProgression = "Vous avez fini un programme sportif, voulez vous consulter vos progressions ?";

  static const String articleWroteBy = "Écrit par ";

  static const String buttonClose = "FERMER";
  static const String buttonRemove = "SUPPRIMER";
  static const String buttonCancel = "ANNULER";
  static const String buttonImport = "AJOUTER";
  static const String buttonRename = "RENOMMER";
  static const String buttonConfirm = "CONFIRMER";
  static const String buttonShow = "AFFICHER";
  static const String buttonEdit = "MODIFIER";
  static const String buttonAdd = "AJOUTER";
  static const String buttonYes = "OUI";
  static const String buttonNo = "NON";
  
  static const String tooltipAdd = "Ajouter";
  static const String tooltipSave = "Sauvegarder les modifs.";
  static const String tooltipRename = "Renommer";

  static const String dialogTitleConfirm = "Confirmation";
  static const String dialogTitleEdit = "Édition";
  static const String dialogTitleImportSportProgram = "Ajouter un programme";
  static const String dialogDescriptionConfirmRemove = "Supprimer ce programme ?";
  static const String dialogTitleWellDone = "Bravo !";

  static const String snackBarError = "Erreur";
  static const String snackBarButtonClose = "FERMER";
  static const String snackBarErrorNotFullyLoaded = "Erreur: A t-elle charger correctement ?";

  static const String tooltipAbout = "A Propos";
  static const String tooltipOpenInBrowser = "Ouvrir dans le navigateur";

  static const String defaultSportProgramName = "Programme sans nom";
  static const String evolutionScreenTitlePrefix = "Évolution: ";

  static const String remameSportProgramDecorationLabelName = "Nom du programme";

  static const String exerciseSelectorAll = "TOUS LES EXERCICES";
  static const String exerciseSelectorItemPrefix = "EXERCICE ";
  
  static const String sportProgramCreatorSelectExerciseEmpty = "Choisir un Exercice...";
  static const String sportProgramCreatorSelectExerciseChange = "Changer l'Exercice...";
  static const String sportProgramCreatorSavePrompt = "Voulez vous enregistrer avant de quitter ?";
  static const String sportProgramCreatorSliderSeries = "Séries";
  static const String sportProgramCreatorSliderRepetitions = "Répétitions";
  static const String sportProgramCreatorSliderWeight = "Poids (kg)";
  static const String sportProgramCreatorSaved = "Modification enregistré.";
  static const String sportProgramCreatorNotSavedNoContent = "Aucune modification enregistré: aucun contenu.";

  static String answerCount(int count) => autoCount(count, "Aucune", "réponse", "réponses");
  static String exerciseCount(int count) => autoCount(count, "Aucun", "exercice", "exercices");
  static String invalidEntryCount(int count) => autoCount(count, null, "entré non valide.", "entrés non valide.");

  static String autoCount(int count, String countNone, String countWord, String countMultipleWord) {
    if (count == 0) {
      return countNone + " " + countWord;
    } else if (count == 1) {
      return count.toString() + " " + countWord;
    } else {
      return count.toString() + " " + countMultipleWord;
    }
  }

  static String formatSportProgramItemSimpleItemDescription(SportProgramItem item) {
    return "${item.series} ser. de ${item.repetitions} rep. à ${item.safeWeight} kg";
  }

  static String formatSportProgramWidgetDescription(SportProgram sportProgram) {
    return "Contient " + Texts.exerciseCount(sportProgram.items.length).toLowerCase() + "\n" + "Fait le " + formatDate(DateTime.parse(sportProgram.createdDate), [dd, '/', mm, '/', yyyy, ' à ', HH, ':', nn, ':', ss]) + "\n" + (sportProgram.isCustom ? "Crée par vous" : "Pour " + sportProgram.target);
  }

  static const Map<BodyBuildingExerciseValueHolderType, String> valueHolderTypeTranslations = {
    BodyBuildingExerciseValueHolderType.series: "Séries",
    BodyBuildingExerciseValueHolderType.repetitions: "Répétitions",
    BodyBuildingExerciseValueHolderType.weight: "Poids (kg)",
  };
}

class AppStorage {
  static const String sportProgramDataFile = "sport-program.json";
  static const String sportProgramJsonItemsKey = "saved";

  static const String sportProgramEvolutionDatabaseFile = "sport-program-evolution.db";
}

class Contact {
  static const String phoneNumber = "tel://+33668770723";
  static const String mailAdress = "mailto:mahedu974@gmail.com";
  static const String websiteUrl = "https://www.monguidemusculation.com/";

  static const String instagramUrl = "https://www.instagram.com/mamaheheruiruisisi/";
  static const String facebookUrl = "https://www.facebook.com/Monguidemusculation/";
  static const String youtubeUrl = null;
}

class MyIcons {
  MyIcons._();

  static const _kFontFam = 'MyIcons';

  /* Font Awesome */
  static const IconData facebook = const IconData(0xf09a, fontFamily: _kFontFam);
  static const IconData youtube = const IconData(0xf167, fontFamily: _kFontFam);
  static const IconData instagram = const IconData(0xf16d, fontFamily: _kFontFam);

  /* Fontelico */
  static const IconData emo_happy = const IconData(0xe800, fontFamily: _kFontFam);
  static const IconData emo_wink = const IconData(0xe801, fontFamily: _kFontFam);
  static const IconData emo_unhappy = const IconData(0xe802, fontFamily: _kFontFam);
  static const IconData emo_sleep = const IconData(0xe803, fontFamily: _kFontFam);
  static const IconData emo_thumbsup = const IconData(0xe804, fontFamily: _kFontFam);
  static const IconData emo_devil = const IconData(0xe805, fontFamily: _kFontFam);
  static const IconData emo_surprised = const IconData(0xe806, fontFamily: _kFontFam);
  static const IconData emo_tongue = const IconData(0xe807, fontFamily: _kFontFam);
  static const IconData emo_coffee = const IconData(0xe808, fontFamily: _kFontFam);
  static const IconData emo_sunglasses = const IconData(0xe809, fontFamily: _kFontFam);
  static const IconData emo_displeased = const IconData(0xe80a, fontFamily: _kFontFam);
  static const IconData emo_beer = const IconData(0xe80b, fontFamily: _kFontFam);
  static const IconData emo_grin = const IconData(0xe80c, fontFamily: _kFontFam);
  static const IconData emo_angry = const IconData(0xe80d, fontFamily: _kFontFam);
  static const IconData emo_saint = const IconData(0xe80e, fontFamily: _kFontFam);
  static const IconData emo_cry = const IconData(0xe80f, fontFamily: _kFontFam);
  static const IconData emo_shoot = const IconData(0xe810, fontFamily: _kFontFam);
  static const IconData emo_squint = const IconData(0xe811, fontFamily: _kFontFam);
  static const IconData emo_laugh = const IconData(0xe812, fontFamily: _kFontFam);
  static const IconData emo_wink2 = const IconData(0xe813, fontFamily: _kFontFam);
  static const IconData crown = const IconData(0xe844, fontFamily: _kFontFam);
}

class WixUrls {
  static const String baseUrl = "https://www.monguidemusculation.com";

  static const String mediaStaticPrefix = "https://static.wixstatic.com/media/";
  static const String forumPage = baseUrl + "/forum/";

  static const String backendBase = baseUrl + "/_functions" + (Constants.debug ? "-dev" : "") + "/";
  static const String backendGetExercices = backendBase + "exercices";
  static const String backendGetSportProgramBase = backendBase + "program/";

  static String formatArticleContentPage(String slug) => baseUrl + "/post/" + slug;
}

class WixData {
  static const String typeAtomicLink = "LINK";
  static const String typeAtomicDevider = "wix-draft-plugin-divider";
  static const String typeAtomicImage = "wix-draft-plugin-image";
  static const String typeAtomicVideo = "wix-draft-plugin-video";
}
