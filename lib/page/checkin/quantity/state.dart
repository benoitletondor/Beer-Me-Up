import 'package:sealed_unions/sealed_unions.dart';

import 'package:beer_me_up/common/mvi/state.dart';

import 'package:beer_me_up/model/checkin.dart';
import 'package:beer_me_up/model/beer.dart';

class CheckInQuantityState extends Union3Impl<
    CheckInQuantityStateBase,
    CheckInQuantityQuantitySelected,
    CheckInQuantityQuantityNotSelectedError> {

  static final Triplet<
      CheckInQuantityStateBase,
      CheckInQuantityQuantitySelected,
      CheckInQuantityQuantityNotSelectedError> factory = const Triplet<
        CheckInQuantityStateBase,
        CheckInQuantityQuantitySelected,
        CheckInQuantityQuantityNotSelectedError> ();

  CheckInQuantityState._(Union3<
      CheckInQuantityStateBase,
      CheckInQuantityQuantitySelected,
      CheckInQuantityQuantityNotSelectedError> union) : super(union);

  factory CheckInQuantityState.base(Beer selectedBeer, DateTime date) => CheckInQuantityState._(factory.first(CheckInQuantityStateBase(selectedBeer, date)));
  factory CheckInQuantityState.quantitySelected(Beer selectedBeer, CheckInQuantity quantity, DateTime date) => CheckInQuantityState._(factory.second(CheckInQuantityQuantitySelected(selectedBeer, quantity, date)));
  factory CheckInQuantityState.error(Beer selectedBeer, DateTime date) => CheckInQuantityState._(factory.third(CheckInQuantityQuantityNotSelectedError(selectedBeer, date)));
}

class CheckInQuantityStateBase extends State {
  final Beer selectedBeer;
  final DateTime date;

  CheckInQuantityStateBase(this.selectedBeer, this.date);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
        other is CheckInQuantityStateBase &&
        runtimeType == other.runtimeType &&
        selectedBeer == other.selectedBeer &&
        date == other.date;

  @override
  int get hashCode =>
      super.hashCode ^
      selectedBeer.hashCode ^
      date.hashCode;
}

class CheckInQuantityQuantitySelected extends State {
  final Beer selectedBeer;
  final CheckInQuantity quantity;
  final DateTime date;

  CheckInQuantityQuantitySelected(this.selectedBeer, this.quantity, this.date);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
        other is CheckInQuantityQuantitySelected &&
        runtimeType == other.runtimeType &&
        selectedBeer == other.selectedBeer &&
        quantity == other.quantity &&
        date == other.date;

  @override
  int get hashCode =>
      super.hashCode ^
      selectedBeer.hashCode ^
      quantity.hashCode ^
      date.hashCode;
}

class CheckInQuantityQuantityNotSelectedError extends State {
  final Beer selectedBeer;
  final DateTime date;

  CheckInQuantityQuantityNotSelectedError(this.selectedBeer, this.date);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
        other is CheckInQuantityQuantityNotSelectedError &&
        runtimeType == other.runtimeType &&
        selectedBeer == other.selectedBeer &&
        date == other.date;

  @override
  int get hashCode =>
      super.hashCode ^
      selectedBeer.hashCode ^
      date.hashCode;
}