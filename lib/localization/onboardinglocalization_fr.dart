import 'package:beer_me_up/localization/localization.dart';

class LocalizationFR implements Localization {
  @override String get onboardingFirstTitle => "Tu t'ai déjà demandé...";
  @override String get onboardingFirstSubText => "\"C'est quoi le nom de cette bière géniale que j'ai bu hier soir ?\"";
  @override String get onboardingFirstCTA => "Ouais ! Carrément !";
  @override String get onboardingSecondTitle => "Comment ça marche ?";
  @override String get onboardingSecondFirstExplainFirst => "Crée un compte";
  @override String get onboardingSecondFirstExplainSecond => ", pour sauvegarder et retrouver tes check-ins de bière";
  @override String get onboardingSecondSecondExplainFirst => "2. Chaque fois que tu bois une bière, ";
  @override String get onboardingSecondSecondExplainSecond => "check-in la";
  @override String get onboardingSecondSecondExplainThird => " dans l'app";
  @override String get onboardingSecondThirdExplainFirst => "3. Accéde à ";
  @override String get onboardingSecondThirdExplainSecond => "ton historique complet";
  @override String get onboardingSecondThirdExplainThird => ", avec des ";
  @override String get onboardingSecondThirdExplainFourth => "stats";
  @override String get onboardingSecondThirdExplainFifth => ", à propos de toutes les bières que tu as bu";
  @override String get onboardingSecondSubText => "C'est aussi simple que ça !";
  @override String get onboardingSecondCTA => "C'est partit";
}