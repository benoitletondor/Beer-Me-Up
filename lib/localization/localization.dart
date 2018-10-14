import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import 'package:beer_me_up/localization/localization_en.dart';
import 'package:beer_me_up/localization/localization_fr.dart';

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

  String get settingsHaptic;
  String get settingsAnalytics;
  String get settingsToS;

  String get homeCheckIn;
  String get homeWelcome;

  String get homeProfileWelcomeContinue;
  String get homeProfileWelcomeStart;
  String get homeProfileThisWeek;
  String get homeProfileOneBeerStart;
  String get homeProfileOneBeerEnd;
  String get homeProfileMultipleBeersStart;
  String get homeProfileMultipleBeersEnd;
  String get homeProfileYourWeek;
  String get homeAllTime;
  String get homeTotalPoints;
  String get homeFavoriteBeers;
  String get homeMostDrankBeer;
  String get homeMostDrankCategory;
  String get homeEmptyWeek;
  String get homeLastTime;
  String get homeNewCheckInTitle;
  String get homeNewCheckInRateCTA;
  String get homeNewCheckInEditRating;

  String get homeHistoryWelcomeStart;

  String get checkInEmptyHistoryHeader;
  String get checkInEmptyResult;
  String get checkInEmptyResultAdvice;
  String get checkInHint;

  String get checkInConfirmTitle;
  String get checkInChangeDateCTA;
  String get checkInSelectQuantity;
  String get checkInNoQuantitySelected;
  String get checkInConfirmCTA;
  String get checkInConfirmDefaultPoints;
  String get checkInConfirmFirstTimeBeer;
  String get checkInConfirmFirstTimeWeekBeer;
  String get checkInConfirmFirstTimeWeekCategory;
  String get checkInConfirmFirstWeekBeer;
  String get checkInConfirmPintQuantity;
  String get checkInConfirmHalfPintQuantity;
  String get checkInConfirmBottleQuantity;

  String get ratingSelectYourRating;
  String get ratingYourRating;
  String get ratingChangeYourRatingHint;

  String get email;
  String get password;
  String get cancel;
  String get settings;
  String get account;
  String get logout;
  String get profile;
  String get history;
  String get times;
  String get loadMore;
  String get errorOccurred;
  String get retry;
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