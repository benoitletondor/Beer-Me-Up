import 'package:sealed_unions/sealed_unions.dart';

import 'package:beer_me_up/common/mvi/state.dart';

import 'package:beer_me_up/model/checkin.dart';
import 'package:beer_me_up/model/beer.dart';

import 'model.dart';

class CheckInConfirmState extends Union4Impl<
    CheckInConfirmStateLoading,
    CheckInConfirmLoad,
    CheckInConfirmQuantityNotSelectedError,
    CheckInConfirmFetchingPointsError> {

  static final Quartet<
      CheckInConfirmStateLoading,
      CheckInConfirmLoad,
      CheckInConfirmQuantityNotSelectedError,
      CheckInConfirmFetchingPointsError> factory = const Quartet<
        CheckInConfirmStateLoading,
        CheckInConfirmLoad,
        CheckInConfirmQuantityNotSelectedError,
        CheckInConfirmFetchingPointsError>();

  CheckInConfirmState._(Union4<
      CheckInConfirmStateLoading,
      CheckInConfirmLoad,
      CheckInConfirmQuantityNotSelectedError,
      CheckInConfirmFetchingPointsError> union) : super(union);

  factory CheckInConfirmState.loading(Beer selectedBeer, DateTime date, CheckInQuantity quantity) => CheckInConfirmState._(factory.first(CheckInConfirmStateLoading(selectedBeer, date, quantity)));
  factory CheckInConfirmState.load(Beer selectedBeer, CheckInQuantity quantity, DateTime date, CheckinPoints points) => CheckInConfirmState._(factory.second(CheckInConfirmLoad(selectedBeer, quantity, date, points)));
  factory CheckInConfirmState.quantityNotSelected(Beer selectedBeer, DateTime date, CheckinPoints points) => CheckInConfirmState._(factory.third(CheckInConfirmQuantityNotSelectedError(selectedBeer, date, points)));
  factory CheckInConfirmState.errorFetchingPoints(Beer selectedBeer, DateTime date, CheckInQuantity quantity, String error) => CheckInConfirmState._(factory.fourth(CheckInConfirmFetchingPointsError(selectedBeer, date, quantity, error)));
}

class CheckInConfirmStateLoading extends State {
  final Beer selectedBeer;
  final DateTime date;
  final CheckInQuantity quantity;

  CheckInConfirmStateLoading(this.selectedBeer, this.date, this.quantity);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
        other is CheckInConfirmStateLoading &&
        runtimeType == other.runtimeType &&
        selectedBeer == other.selectedBeer &&
        date == other.date &&
        quantity == other.quantity;

  @override
  int get hashCode =>
      super.hashCode ^
      selectedBeer.hashCode ^
      date.hashCode ^
      quantity.hashCode;
}

class CheckInConfirmLoad extends State {
  final Beer selectedBeer;
  final CheckInQuantity quantity;
  final DateTime date;
  final CheckinPoints points;

  CheckInConfirmLoad(this.selectedBeer, this.quantity, this.date, this.points);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
        other is CheckInConfirmLoad &&
        runtimeType == other.runtimeType &&
        selectedBeer == other.selectedBeer &&
        quantity == other.quantity &&
        date == other.date &&
        points == other.points;

  @override
  int get hashCode =>
      super.hashCode ^
      selectedBeer.hashCode ^
      quantity.hashCode ^
      date.hashCode ^
      points.hashCode;
}

class CheckInConfirmQuantityNotSelectedError extends State {
  final Beer selectedBeer;
  final DateTime date;
  final CheckinPoints points;

  CheckInConfirmQuantityNotSelectedError(this.selectedBeer, this.date, this.points);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
        other is CheckInConfirmQuantityNotSelectedError &&
        runtimeType == other.runtimeType &&
        selectedBeer == other.selectedBeer &&
        date == other.date &&
        points == other.points;

  @override
  int get hashCode =>
      super.hashCode ^
      selectedBeer.hashCode ^
      date.hashCode ^
      points.hashCode;
}

class CheckInConfirmFetchingPointsError extends State {
  final Beer selectedBeer;
  final DateTime date;
  final CheckInQuantity quantity;
  final String error;

  CheckInConfirmFetchingPointsError(this.selectedBeer, this.date, this.quantity, this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CheckInConfirmFetchingPointsError &&
              runtimeType == other.runtimeType &&
              selectedBeer == other.selectedBeer &&
              date == other.date &&
              quantity == other.quantity &&
              error == other.error;

  @override
  int get hashCode =>
      super.hashCode ^
      selectedBeer.hashCode ^
      date.hashCode ^
      quantity.hashCode ^
      error.hashCode;
}