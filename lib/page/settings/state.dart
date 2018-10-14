import 'package:sealed_unions/sealed_unions.dart';

import 'package:beer_me_up/common/mvi/state.dart';

class SettingsState extends Union2Impl<SettingsStateLoading, SettingsStateLoad> {

  static final Doublet<SettingsStateLoading, SettingsStateLoad> factory
    = const Doublet<SettingsStateLoading, SettingsStateLoad>();

  SettingsState._(Union2<SettingsStateLoading, SettingsStateLoad> union) : super(union);

  factory SettingsState.loading() => SettingsState._(factory.first(SettingsStateLoading()));
  factory SettingsState.load(String email, bool hapticFeedbackEnabled, bool analyticsEnabled) => SettingsState._(factory.second(SettingsStateLoad(email, hapticFeedbackEnabled, analyticsEnabled)));
}

class SettingsStateLoading extends State {}

class SettingsStateLoad extends State {
  final String email;
  final bool hapticFeedbackEnabled;
  final bool analyticsEnabled;

  SettingsStateLoad(this.email, this.hapticFeedbackEnabled, this.analyticsEnabled);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
        other is SettingsStateLoad &&
        runtimeType == other.runtimeType &&
        email == other.email &&
        hapticFeedbackEnabled == other.hapticFeedbackEnabled &&
        analyticsEnabled == other.analyticsEnabled;

  @override
  int get hashCode =>
      super.hashCode ^
      email.hashCode ^
      hapticFeedbackEnabled.hashCode ^
      analyticsEnabled.hashCode;
}