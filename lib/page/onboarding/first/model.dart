import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'state.dart';

class OnboardingFirstPageViewModel extends BaseViewModel<OnboardingFirstPageState> {
  @override
  OnboardingFirstPageState initialState() => OnboardingFirstPageState.onboarding();
}