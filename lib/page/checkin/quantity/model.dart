import 'dart:async';

import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'state.dart';
import 'checkinquantitypage.dart';
import 'package:beer_me_up/model/checkin.dart';
import 'package:beer_me_up/model/beer.dart';

class CheckInQuantityViewModel extends BaseViewModel<CheckInQuantityState> {
  final Beer selectedBeer;

  CheckInQuantityViewModel(
      this.selectedBeer,
      Stream<CheckInQuantity> onQuantitySelected,
      Stream<Null> onCheckInConfirmed) {

    onQuantitySelected.listen(_onQuantitySelected);
    onCheckInConfirmed.listen(_onCheckInConfirmed);
  }

  @override
  CheckInQuantityState initialState() => new CheckInQuantityState.base(selectedBeer);

  _onQuantitySelected(CheckInQuantity quantity) async {
    setState(new CheckInQuantityState.quantitySelected(selectedBeer, quantity));
  }

  _onCheckInConfirmed(Null event) async {
    final selectedQuantity = getState().currentStateSelectedQuantity;
    if( selectedQuantity == null ) {
      setState(new CheckInQuantityState.error(selectedBeer));
      return;
    }

    pop({
      SELECTED_CHECKIN_QUANTITY_KEY: selectedQuantity,
    });
  }
}