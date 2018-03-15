import 'package:sealed_unions/sealed_unions.dart';

import 'package:beer_me_up/model/beer.dart';

class ProfileState extends Union3Impl<
    ProfileStateLoading,
    ProfileStateLoad,
    ProfileStateError> {

  static final Triplet<
      ProfileStateLoading,
      ProfileStateLoad,
      ProfileStateError> factory = const Triplet<
      ProfileStateLoading,
      ProfileStateLoad,
      ProfileStateError>();

  ProfileState._(Union3<
      ProfileStateLoading,
      ProfileStateLoad,
      ProfileStateError> union) : super(union);

  factory ProfileState.loading() => new ProfileState._(factory.first(new ProfileStateLoading()));
  factory ProfileState.load(List<Beer> beers) => new ProfileState._(factory.second(new ProfileStateLoad(beers)));
  factory ProfileState.error(String error) => new ProfileState._(factory.third(new ProfileStateError(error)));
}

class ProfileStateLoading {}
class ProfileStateLoad {
  final List<Beer> beers;

  ProfileStateLoad(this.beers);
}
class ProfileStateError {
  final String error;

  ProfileStateError(this.error);
}