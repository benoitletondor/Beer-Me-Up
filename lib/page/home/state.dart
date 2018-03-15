import 'package:sealed_unions/sealed_unions.dart';

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

  factory HomeState.authenticating() => new HomeState._(factory.first(new HomeStateAuthenticating()));
  factory HomeState.loading() => new HomeState._(factory.second(new HomeStateLoading()));
  factory HomeState.tabProfile() => new HomeState._(factory.third(new HomeStateTabProfile()));
  factory HomeState.tabHistory() => new HomeState._(factory.fourth(new HomeStateTabHistory()));
  factory HomeState.error(String error) => new HomeState._(factory.fifth(new HomeStateError(error)));
}

class HomeStateAuthenticating {}
class HomeStateLoading {}
class HomeStateTabProfile {}
class HomeStateTabHistory {}
class HomeStateError {
  final String error;

  HomeStateError(this.error);
}