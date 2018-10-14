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

  @override String get loginCreateYourAccount => "Create your account";
  @override String get loginSignUpCTA => "Sign-up";
  @override String get loginPrivacyExplain => "Like privacy? We feel you. We don’t use or sell your data.";
  @override String get loginPrivacyReadCTA => "Touch to read our privacy policy.";
  @override String get loginOr => "OR";
  @override String get loginSignInGoogle => "Sign-in with Google";
  @override String get loginSignInFacebook => "Sign-in with Facebook";
  @override String get loginAlreadyHaveAccountCTA => "Already have an account? Sign-in";
  @override String get loginSignIn => "Sign-in with your account";
  @override String get loginSignInCTA => "Sign-in";
  @override String get loginForgotPasswordCTA => "Forgot password?";
  @override String get loginNoAccountCTA => "Don't have an account yet? Sign-up";

  @override String get forgotPasswordTitle => "Retrieve password";
  @override String get forgotPasswordExplain => "Enter your login email and we'll send you instructions to reset your password";
  @override String get forgotPasswordResetCTA => "Reset password";
  @override String get forgotPasswordNoEmailTitle => "Empty email";
  @override String get forgotPasswordNoEmailExplain => "Please provide an email";
  @override String get forgotPasswordSuccessMessage => "Email with instructions has been send.";
  @override String get forgotPasswordErrorMessage => "An error occurred while sending the email with instructions";

  @override String get consentTitle => "Create your account";
  @override String get consentTOSExplain => "By creating your account, you agree to the Terms of Service and Privacy Policy.";
  @override String get consentAgeExplain => "You also certify to be over legal drinking age (18 or 21 depending on your country), using this app is prohibited for underage people.";
  @override String get consentWarningExplain => "Finally, we remind you that alcohol is dangerous for you and other people: drink responsibly.";
  @override String get consentAcceptCTA => "Create the account";

  @override String get tosTitle => "ToS and Privacy Policy";

  @override String get settingsHaptic => "Haptic feedback (vibration) on touch";
  @override String get settingsAnalytics => "Help enhance experience by sending usage statistics";
  @override String get settingsToS => "Read terms and conditions";

  @override String get homeCheckIn => "Check-in";
  @override String get homeWelcome => "Welcome into your own beer museum";

  @override String get homeProfileWelcomeContinue => "Continue to check-in: One more to access your profile.";
  @override String get homeProfileWelcomeStart => "Check the next beer you have into the app to build your profile.";
  @override String get homeProfileThisWeek => "This week";
  @override String get homeProfileOneBeerStart => "You only had ";
  @override String get homeProfileOneBeerEnd => " beer";
  @override String get homeProfileMultipleBeersStart => "You had ";
  @override String get homeProfileMultipleBeersEnd => " different beers";
  @override String get homeProfileYourWeek => "Your week";
  @override String get homeAllTime => "All time";
  @override String get homeTotalPoints => "Total of points: ";
  @override String get homeFavoriteBeers => "Your best rated beers";
  @override String get homeMostDrankBeer => "The beer you had the most";
  @override String get homeMostDrankCategory => "The beer category your had the most";
  @override String get homeEmptyWeek => "Nothing checked-in this week so far";
  @override String get homeLastTime => "Last time:";
  @override String get homeNewCheckInTitle => "New check-in!";
  @override String get homeNewCheckInRateCTA => "Rate this beer";
  @override String get homeNewCheckInEditRating => "Change rating";

  @override String get homeHistoryWelcomeStart => "Check the next beer you have into the app to start your history";

  @override String get checkInEmptyHistoryHeader => "Recently checked-in:";
  @override String get checkInEmptyResult => "Can't find any beer matching your search";
  @override String get checkInEmptyResultAdvice => "Try to type more or check the spelling";
  @override String get checkInHint => "Type a beer name";

  @override String get checkInConfirmTitle => "Confirm check-in";
  @override String get checkInChangeDateCTA => "Change date";
  @override String get checkInSelectQuantity => "Select quantity";
  @override String get checkInNoQuantitySelected => "Please select a quantity to confirm checkin";
  @override String get checkInConfirmCTA => "Check-in";
  @override String get checkInConfirmDefaultPoints => "Yet another beer";
  @override String get checkInConfirmFirstTimeBeer => "First time ever with this beer";
  @override String get checkInConfirmFirstTimeWeekBeer => "First time this week with this beer";
  @override String get checkInConfirmFirstTimeWeekCategory => "First time this week with this kind of beer";
  @override String get checkInConfirmFirstWeekBeer => "First beer of the week";
  @override String get checkInConfirmPintQuantity => "Pint";
  @override String get checkInConfirmHalfPintQuantity => "Half-pint";
  @override String get checkInConfirmBottleQuantity => "Bottle";

  @override String get ratingSelectYourRating => "Rate this beer";
  @override String get ratingYourRating => "Your rating for this beer:";
  @override String get ratingChangeYourRatingHint => "(Touch a star to change it)";

  @override String get email => "Email";
  @override String get password => "Password";
  @override String get cancel => "Cancel";
  @override String get settings => "Settings";
  @override String get account => "Account";
  @override String get logout => "Logout";
  @override String get profile => "Profile";
  @override String get history => "History";
  @override String get times => "times";
  @override String get loadMore => "Load more";
  @override String get errorOccurred => "An error occurred";
  @override String get retry => "Retry";
}