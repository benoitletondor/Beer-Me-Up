import 'package:sealed_unions/sealed_unions.dart';

import 'package:beer_me_up/common/mvi/state.dart';

class OnboardingFirstPageState extends Union1Impl<OnboardingFirstPageStateOnboarding> {

  static final Singlet<OnboardingFirstPageStateOnboarding> factory
    = const Singlet<OnboardingFirstPageStateOnboarding>();

  OnboardingFirstPageState._(Union1<OnboardingFirstPageStateOnboarding> union) : super(union);

  factory OnboardingFirstPageState.onboarding() => OnboardingFirstPageState._(factory.first(OnboardingFirstPageStateOnboarding()));
}

class OnboardingFirstPageStateOnboarding extends State {}