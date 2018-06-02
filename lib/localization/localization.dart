import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import 'package:beer_me_up/localization/onboardinglocalization_en.dart';
import 'package:beer_me_up/localization/onboardinglocalization_fr.dart';

abstract class Localization {
  static Localization of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization);
  }

  String get onboardingFirstTitle;
  String get onboardingFirstSubText;
  String get onboardingFirstCTA;
  String get onboardingSecondTitle;
  String get onboardingSecondFirstExplainFirst;
  String get onboardingSecondFirstExplainSecond;
  String get onboardingSecondSecondExplainFirst;
  String get onboardingSecondSecondExplainSecond;
  String get onboardingSecondSecondExplainThird;
  String get onboardingSecondThirdExplainFirst;
  String get onboardingSecondThirdExplainSecond;
  String get onboardingSecondThirdExplainThird;
  String get onboardingSecondThirdExplainFourth;
  String get onboardingSecondThirdExplainFifth;
  String get onboardingSecondSubText;
  String get onboardingSecondCTA;
}

class BeerMeUpLocalizationsDelegate extends LocalizationsDelegate<Localization> {
  const BeerMeUpLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<Localization> load(Locale locale) => _load(locale);

  static Future<Localization> _load(Locale locale) async {
    final String name = (locale.countryCode == null || locale.countryCode.isEmpty) ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    Intl.defaultLocale = localeName;

    if( locale.languageCode == "fr" ) {
      return LocalizationFR();
    } else {
      return LocalizationEN();
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<Localization> old) => false;
}