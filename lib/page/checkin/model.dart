import 'dart:async';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'package:beer_me_up/common/exceptionprint.dart';
import 'state.dart';
import 'package:beer_me_up/page/checkin/quantity/checkinquantitypage.dart';
import 'checkinpage.dart';
import 'package:beer_me_up/service/userdataservice.dart';
import 'package:beer_me_up/model/beer.dart';

class CheckInViewModel extends BaseViewModel<CheckInState> {
  final UserDataService _dataService;

  CheckInViewModel(
      this._dataService,
      Stream<String> onUserInputChanged,
      Stream<Beer> onBeerSelected,) {

    onUserInputChanged.listen(_onUserInput);
    onBeerSelected.listen(_onBeerSelected);
  }

  @override
  CheckInState initialState() => CheckInState.empty();

  _onUserInput(String userInput) async {
    if( userInput == null || userInput.trim().isEmpty ) {
      setState(CheckInState.empty());
    }

    final CheckInState state = getState();

    List<Beer> currentPredictions;
    if( state != null && state.currentStatePredictions != null ) {
      currentPredictions = state.currentStatePredictions;
    } else {
      currentPredictions = List<Beer>(0);
    }

    setState(CheckInState.searching(currentPredictions));

    try {
      final matchingBeers = await _dataService.findBeersMatching(userInput);
      setState(CheckInState.predictions(matchingBeers));
    } catch( e, stackTrace ) {
      printException(e, stackTrace, "Error looking for beers matching $userInput");
      setState(CheckInState.error(e.toString()));
    }
  }

  _onBeerSelected(Beer selectedBeer) async {
    final quantityResult = await push(MaterialPageRoute(
      builder: (BuildContext context) => CheckInQuantityPage(selectedBeer: selectedBeer)
    ));

    if( quantityResult != null &&
        quantityResult[SELECTED_CHECKIN_QUANTITY_KEY] != null &&
        quantityResult[SELECTED_CHECKIN_DATE_KEY] != null ) {
      pop({
        SELECTED_BEER_KEY: selectedBeer,
        SELECTED_QUANTITY_KEY: quantityResult[SELECTED_CHECKIN_QUANTITY_KEY],
        SELECTED_DATE_KEY: quantityResult[SELECTED_CHECKIN_DATE_KEY]
      });
    }
  }
}