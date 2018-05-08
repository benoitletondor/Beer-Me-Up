import 'dart:async';

import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'state.dart';
import 'checkinquantitypage.dart';
import 'package:beer_me_up/model/checkin.dart';
import 'package:beer_me_up/model/beer.dart';

class CheckInQuantityViewModel extends BaseViewModel<CheckInQuantityState> {
  final Beer selectedBeer;
  DateTime date = new DateTime.now();
  CheckInQuantity quantity;

  CheckInQuantityViewModel(
      this.selectedBeer,
      Stream<CheckInQuantity> onQuantitySelected,
      Stream<Null> onCheckInConfirmed,
      Stream<Null> changeDateTimeClicked) {

    onQuantitySelected.listen(_onQuantitySelected);
    onCheckInConfirmed.listen(_onCheckInConfirmed);
    changeDateTimeClicked.listen(_onChangeDateTimeClicked);
  }

  @override
  CheckInQuantityState initialState() => CheckInQuantityState.base(selectedBeer, date);

  _onQuantitySelected(CheckInQuantity quantity) async {
    this.quantity = quantity;
    setState(CheckInQuantityState.quantitySelected(selectedBeer, quantity, date));
  }

  _onChangeDateTimeClicked(Null event) async {
    this.date = await showDateTimePicker(getBuildContext(), date);

    if( quantity != null ) {
      setState(CheckInQuantityState.quantitySelected(selectedBeer, quantity, date));
    } else {
      setState(CheckInQuantityState.base(selectedBeer, date));
    }
  }

  _onCheckInConfirmed(Null event) async {
    if( quantity == null ) {
      setState(CheckInQuantityState.error(selectedBeer, date));
      return;
    }

    pop({
      SELECTED_CHECKIN_QUANTITY_KEY: quantity,
      SELECTED_CHECKIN_DATE_KEY: date,
    });
  }
}