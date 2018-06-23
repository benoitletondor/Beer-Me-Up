import 'package:sealed_unions/sealed_unions.dart';

import 'package:beer_me_up/common/mvi/state.dart';
import 'package:beer_me_up/model/checkin.dart';

class CheckInDisplayState extends Union3Impl<
    CheckInDisplayStateLoading,
    CheckInDisplayStateLoad,
    CheckInDisplayStateError> {

  static final Triplet<
      CheckInDisplayStateLoading,
      CheckInDisplayStateLoad,
      CheckInDisplayStateError> factory
    = const Triplet<
        CheckInDisplayStateLoading,
        CheckInDisplayStateLoad,
        CheckInDisplayStateError>();

  CheckInDisplayState._(Union3<
      CheckInDisplayStateLoading,
      CheckInDisplayStateLoad,
      CheckInDisplayStateError> union) : super(union);

  factory CheckInDisplayState.loading(CheckIn checkIn) => CheckInDisplayState._(factory.first(CheckInDisplayStateLoading(checkIn)));
  factory CheckInDisplayState.load(CheckIn checkIn, int rating) => CheckInDisplayState._(factory.second(CheckInDisplayStateLoad(checkIn, rating)));
  factory CheckInDisplayState.error(CheckIn checkIn, String error) => CheckInDisplayState._(factory.third(CheckInDisplayStateError(checkIn, error)));
}

class CheckInDisplayStateLoading extends State {
  final CheckIn checkIn;

  CheckInDisplayStateLoading(this.checkIn);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CheckInDisplayStateLoading &&
              runtimeType == other.runtimeType &&
              checkIn == other.checkIn;

  @override
  int get hashCode =>
      super.hashCode ^
      checkIn.hashCode;
}

class CheckInDisplayStateLoad extends State {
  final CheckIn checkIn;
  final int rating;

  CheckInDisplayStateLoad(this.checkIn, this.rating);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
        other is CheckInDisplayStateLoad &&
        runtimeType == other.runtimeType &&
        checkIn == other.checkIn &&
        rating == other.rating;

  @override
  int get hashCode =>
      super.hashCode ^
      checkIn.hashCode ^
      rating.hashCode;
}

class CheckInDisplayStateError extends State {
  final CheckIn checkIn;
  final String error;

  CheckInDisplayStateError(this.checkIn, this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CheckInDisplayStateError &&
              runtimeType == other.runtimeType &&
              checkIn == other.checkIn &&
              error == other.error;

  @override
  int get hashCode =>
      super.hashCode ^
      checkIn.hashCode ^
      error.hashCode;
}