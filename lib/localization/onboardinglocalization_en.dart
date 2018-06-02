import 'package:beer_me_up/localization/localization.dart';

class LocalizationEN implements Localization {
  @override String get onboardingFirstTitle => "Ever wondered...";
  @override String get onboardingFirstSubText => "\"What was that beer I drank last time that tasted so good?\"";
  @override String get onboardingFirstCTA => "Yeah! Totally!";
  @override String get onboardingSecondTitle => "How does it work?";
  @override String get onboardingSecondFirstExplainFirst => "Create an account";
  @override String get onboardingSecondFirstExplainSecond => ", to save and retreive your beer check-ins at any time";
  @override String get onboardingSecondSecondExplainFirst => "2. Every time you drink a beer, just ";
  @override String get onboardingSecondSecondExplainSecond => "check-in it";
  @override String get onboardingSecondSecondExplainThird => " into the app";
  @override String get onboardingSecondThirdExplainFirst => "3. Get a full ";
  @override String get onboardingSecondThirdExplainSecond => "history";
  @override String get onboardingSecondThirdExplainThird => ", with ";
  @override String get onboardingSecondThirdExplainFourth => "stats";
  @override String get onboardingSecondThirdExplainFifth => ", about your all the beers you drank";
  @override String get onboardingSecondSubText => "And that's it! That easy!";
  @override String get onboardingSecondCTA => "Let's go";
}