import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/utils/constants.dart';

import 'package:uni_links/uni_links.dart';

class LinkManager extends BaseManager {
  @override
  void initialize() {
    listenToRequest();
  }

  void onInitialFallback(Uri initialUri) {
    processReceivedUri(initialUri);
  }

  void onBackgroundFallback(Uri uri) {
    processReceivedUri(uri);
  }

  void processReceivedUri(Uri uri) {
    String path = uri.path;

    if (path.length == 0) {
      return;
    }

    switch (uri.scheme) {
      case "http":
      case "https":
        if (path.startsWith("/programme/")) {
          onSportProgramTokenReceived(path.substring("/programme/".length));
        }
        break;

      case Constants.customScheme:
        switch (uri.host.toLowerCase()) {
          case "sport-program":
            onSportProgramTokenReceived(path.substring("/".length));
            break;

          default:
            return;
        }
        break;

      default:
        return;
    }
  }

  void onSportProgramTokenReceived(String token) {
    print("Received token: $token");
    Managers.sportProgramManager.onReceivedToken(token);
  }

  void listenToRequest() async {
    try {
      Uri initialUri = await getInitialUri();

      if (initialUri != null) {
        print("Started application with uri: $initialUri");
        onInitialFallback(initialUri);
      }
    } catch (exception) {
      print("An error occured when listening for the initial uri.");
      print(exception);
    }

    getUriLinksStream().listen((Uri uri) {
      if (uri != null) {
        print("Catch uri: $uri");
        onBackgroundFallback(uri);
      }
    }, onError: (exception) {
      print("An error occured when listening for update uris.");
      print(exception);
    });
  }
}
