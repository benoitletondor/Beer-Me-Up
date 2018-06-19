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

  String _currentUserInput;

  final List<Beer> _lastBeersCheckedIn = List();
  final List<Beer> _currentPredictions = List();

  CheckInViewModel(
      this._dataService,
      Stream<String> onUserInputChanged,
      Stream<Beer> onBeerSelected,) {

    onUserInputChanged.listen(_onUserInput);
    onBeerSelected.listen(_onBeerSelected);
  }

  @override
  Stream<CheckInState> bind(BuildContext context) {
    _loadLastBeersCheckedIn();

    return super.bind(context);
  }

  @override
  CheckInState initialState() => CheckInState.empty();

  _loadLastBeersCheckedIn() async {
    try {
      this._lastBeersCheckedIn.addAll(await _dataService.fetchLastCheckedInBeers());

      if( this._lastBeersCheckedIn.isNotEmpty && (_currentUserInput == null || _currentUserInput.trim().isEmpty) ) {
        setState(CheckInState.emptyLastBeers(this._lastBeersCheckedIn));
      }
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error loading last beers checked-in");
    }
  }

  _onUserInput(String userInput) async {
    _currentUserInput = userInput;

    if( userInput == null || userInput.trim().isEmpty ) {
      _currentPredictions.clear();

      if( _lastBeersCheckedIn.isEmpty ) {
        setState(CheckInState.empty());
      } else {
        setState(CheckInState.emptyLastBeers(_lastBeersCheckedIn));
      }

      return;
    }

    if( _currentPredictions.isNotEmpty ) {
      setState(CheckInState.searchingWithPredictions(_currentPredictions));
    } else {
      setState(CheckInState.searching());
    }

    try {
      final matchingBeers = await _dataService.findBeersMatching(userInput);

      _currentPredictions.clear();

      if( matchingBeers.isNotEmpty ) {
        _currentPredictions.addAll(matchingBeers);
        setState(CheckInState.predictions(matchingBeers));
      } else {
        setState(CheckInState.noPredictions());
      }
    } catch( e, stackTrace ) {
      printException(e, stackTrace, "Error looking for beers matching $userInput");
      _currentPredictions.clear();

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