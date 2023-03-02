import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'app_localizations.dart';


part 'app_store.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {


  @observable
  String selectedLanguageCode = DEFAULT_LANGUAGE;

  static String get DEFAULT_LANGUAGE => 'en';





  @action
  Future<void> setLanguage(String val) async {
    selectedLanguageCode = val;
    selectedLanguageDataModel = getSelectedLanguageModel();

    await setValue(SELECTED_LANGUAGE_CODE, selectedLanguageCode);

    language = await AppLocalizations().load(Locale(selectedLanguageCode));
    // errorInternetNotAvailable=language!.errorInternetNotAvailable;
  }
}
