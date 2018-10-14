import 'package:sealed_unions/sealed_unions.dart';

import 'package:beer_me_up/common/mvi/state.dart';
import 'package:beer_me_up/model/beer.dart';

class RatingState extends Union3Impl<
    RatingStateLoading,
    RatingStateLoad,
    RatingStateError> {

  static final Triplet<
      RatingStateLoading,
      RatingStateLoad,
      RatingStateError> factory
    = const Triplet<
        RatingStateLoading,
        RatingStateLoad,
        RatingStateError>();

  RatingState._(Union3<
      RatingStateLoading,
      RatingStateLoad,
      RatingStateError> union) : super(union);

  factory RatingState.loading(Beer beer) => RatingState._(factory.first(RatingStateLoading(beer)));
  factory RatingState.load(Beer beer, int rating) => RatingState._(factory.second(RatingStateLoad(beer, rating)));
  factory RatingState.error(Beer beer, String error) => RatingState._(factory.third(RatingStateError(beer, error)));
}

class RatingStateLoading extends State {
  final Beer beer;

  RatingStateLoading(this.beer);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RatingStateLoading &&
              runtimeType == other.runtimeType &&
              beer == other.beer;

  @override
  int get hashCode =>
      super.hashCode ^
      beer.hashCode;
}

class RatingStateLoad extends State {
  final Beer beer;
  final int rating;

  RatingStateLoad(this.beer, this.rating);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
        other is RatingStateLoad &&
        runtimeType == other.runtimeType &&
        beer == other.beer &&
        rating == other.rating;

  @override
  int get hashCode =>
      super.hashCode ^
      beer.hashCode ^
      rating.hashCode;
}

class RatingStateError extends State {
  final Beer beer;
  final String error;

  RatingStateError(this.beer, this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RatingStateError &&
              runtimeType == other.runtimeType &&
              beer == other.beer &&
              error == other.error;

  @override
  int get hashCode =>
      super.hashCode ^
      beer.hashCode ^
      error.hashCode;
}