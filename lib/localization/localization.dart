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

  String get loginCreateYourAccount;
  String get loginSignUpCTA;
  String get loginPrivacyExplain;
  String get loginPrivacyReadCTA;
  String get loginOr;
  String get loginSignInGoogle;
  String get loginSignInFacebook;
  String get loginAlreadyHaveAccountCTA;
  String get loginSignIn;
  String get loginSignInCTA;
  String get loginForgotPasswordCTA;
  String get loginNoAccountCTA;

  String get forgotPasswordTitle;
  String get forgotPasswordExplain;
  String get forgotPasswordResetCTA;
  String get forgotPasswordNoEmailTitle;
  String get forgotPasswordNoEmailExplain;
  String get forgotPasswordSuccessMessage;
  String get forgotPasswordErrorMessage;

  String get consentTitle;
  String get consentTOSExplain;
  String get consentAgeExplain;
  String get consentWarningExplain;
  String get consentAcceptCTA;

  String get tosTitle;

  String get email;
  String get password;
  String get cancel;
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