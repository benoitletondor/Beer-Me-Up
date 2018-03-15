import 'package:sealed_unions/sealed_unions.dart';

class OnboardingState extends Union1Impl<OnboardingStateOnboarding> {

  static final Singlet<OnboardingStateOnboarding> factory
    = const Singlet<OnboardingStateOnboarding>();

  OnboardingState._(Union1<OnboardingStateOnboarding> union) : super(union);

  factory OnboardingState.onboarding() => new OnboardingState._(factory.first(new OnboardingStateOnboarding()));
}

class OnboardingStateOnboarding {}