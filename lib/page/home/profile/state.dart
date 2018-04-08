import 'package:sealed_unions/sealed_unions.dart';

import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/model/beercheckinsdata.dart';

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
  factory ProfileState.load(
    BeerCategory favouriteBeerCategory,
    BeerCheckInsData favouriteBeer) => new ProfileState._(factory.second(new ProfileStateLoad(
      favouriteBeerCategory,
      favouriteBeer,
    )
  ));
  factory ProfileState.error(String error) => new ProfileState._(factory.third(new ProfileStateError(error)));
}

class ProfileStateLoading {}
class ProfileStateLoad {
  final BeerCategory favouriteBeerCategory;
  final BeerCheckInsData favouriteBeer;

  ProfileStateLoad(this.favouriteBeerCategory, this.favouriteBeer);
}
class ProfileStateError {
  final String error;

  ProfileStateError(this.error);
}