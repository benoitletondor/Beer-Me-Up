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

  @override String get loginCreateYourAccount => "Créer ton compte";
  @override String get loginEmail => "Email";
  @override String get loginPassword => "Mot de passe";
  @override String get loginSignUpCTA => "Créer mon compte";
  @override String get loginPrivacyExplain => "Nous protégeons ta vie privée. Nous ne vendons et n'utilisons pas tes données.";
  @override String get loginPrivacyReadCTA => "Touchez ici pour lire nos conditions d'utilisation.";
  @override String get loginOr => "OU";
  @override String get loginSignInGoogle => "Se connecter avec Google";
  @override String get loginSignInFacebook => "Se connecter avec Facebook";
  @override String get loginAlreadyHaveAccountCTA => "Tu as déjà un compte ? Connecte toi";
  @override String get loginSignIn => "Connecte toi à ton compte";
  @override String get loginSignInCTA => "Me connecter";
  @override String get loginForgotPasswordCTA => "Mot de passe oublié ?";
  @override String get loginNoAccountCTA => "Tu n'as pas de compte ? Crée-en un";
}