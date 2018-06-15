import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'package:beer_me_up/common/exceptionprint.dart';
import 'state.dart';
import 'package:beer_me_up/page/checkin/confirm/checkinconfirmpage.dart';
import 'checkinpage.dart';
import 'package:beer_me_up/service/userdataservice.dart';
import 'package:beer_me_up/model/beer.dart';

class CheckInViewModel extends BaseViewModel<CheckInState> {
  final UserDataService _dataService;

  final List<Beer> currentPredictions = List();

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
      currentPredictions.clear();
      setState(CheckInState.empty());
      return;
    }

    if( currentPredictions.isNotEmpty ) {
      setState(CheckInState.searchingWithPredictions(currentPredictions));
    } else {
      setState(CheckInState.searching());
    }

    try {
      final matchingBeers = await _dataService.findBeersMatching(userInput);

      currentPredictions.clear();

      if( matchingBeers.isNotEmpty ) {
        currentPredictions.addAll(matchingBeers);
        setState(CheckInState.predictions(matchingBeers));
      } else {
        setState(CheckInState.noPredictions());
      }
    } catch( e, stackTrace ) {
      printException(e, stackTrace, "Error looking for beers matching $userInput");
      currentPredictions.clear();

      if( e is HttpException ) {
        setState(CheckInState.error("An error occurred while processing the request."));
      } else {
        setState(CheckInState.error(e.toString()));
      }
    }
  }

  _onBeerSelected(Beer selectedBeer) async {
    final confirmResult = await push(MaterialPageRoute(
      builder: (BuildContext context) => CheckInConfirmPage(selectedBeer: selectedBeer)
    ));

    if( confirmResult != null &&
        confirmResult[SELECTED_CHECKIN_QUANTITY_KEY] != null &&
        confirmResult[SELECTED_CHECKIN_DATE_KEY] != null &&
        confirmResult[CHECKIN_POINTS_KEY] != null ) {
      pop({
        SELECTED_BEER_KEY: selectedBeer,
        SELECTED_QUANTITY_KEY: confirmResult[SELECTED_CHECKIN_QUANTITY_KEY],
        SELECTED_DATE_KEY: confirmResult[SELECTED_CHECKIN_DATE_KEY],
        POINTS_KEY: confirmResult[CHECKIN_POINTS_KEY],
      });
    }
  }
}