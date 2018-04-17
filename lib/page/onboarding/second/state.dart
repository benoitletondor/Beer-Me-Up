import 'package:sealed_unions/sealed_unions.dart';

import 'package:beer_me_up/common/mvi/state.dart';

class OnboardingSecondPageState extends Union1Impl<OnboardingSecondPageStateOnboarding> {

  static final Singlet<OnboardingSecondPageStateOnboarding> factory
    = const Singlet<OnboardingSecondPageStateOnboarding>();

  OnboardingSecondPageState._(Union1<OnboardingSecondPageStateOnboarding> union) : super(union);

  factory OnboardingSecondPageState.onboarding() => new OnboardingSecondPageState._(factory.first(new OnboardingSecondPageStateOnboarding()));
}

class OnboardingSecondPageStateOnboarding extends State {}