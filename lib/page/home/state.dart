import 'package:sealed_unions/sealed_unions.dart';

import 'package:beer_me_up/common/mvi/state.dart';

class HomeState extends Union5Impl<
    HomeStateAuthenticating,
    HomeStateLoading,
    HomeStateTabProfile,
    HomeStateTabHistory,
    HomeStateError> {

  static final Quintet<
      HomeStateAuthenticating,
      HomeStateLoading,
      HomeStateTabProfile,
      HomeStateTabHistory,
      HomeStateError> factory = const Quintet<
      HomeStateAuthenticating,
      HomeStateLoading,
      HomeStateTabProfile,
      HomeStateTabHistory,
      HomeStateError>();

  HomeState._(Union5<
      HomeStateAuthenticating,
      HomeStateLoading,
      HomeStateTabProfile,
      HomeStateTabHistory,
      HomeStateError> union) : super(union);

  factory HomeState.authenticating() => HomeState._(factory.first(HomeStateAuthenticating()));
  factory HomeState.loading() => HomeState._(factory.second(HomeStateLoading()));
  factory HomeState.tabProfile() => HomeState._(factory.third(HomeStateTabProfile()));
  factory HomeState.tabHistory() => HomeState._(factory.fourth(HomeStateTabHistory()));
  factory HomeState.error(String error) => HomeState._(factory.fifth(HomeStateError(error)));
}

class HomeStateAuthenticating extends State {}
class HomeStateLoading extends State {}
class HomeStateTabProfile extends State {}
class HomeStateTabHistory extends State {}

class HomeStateError extends State {
  final String error;

  HomeStateError(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
        other is HomeStateError &&
        runtimeType == other.runtimeType &&
        error == other.error;

  @override
  int get hashCode =>
      super.hashCode ^
      error.hashCode;
}