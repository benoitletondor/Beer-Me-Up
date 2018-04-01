import 'dart:async';

import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'package:beer_me_up/common/exceptionprint.dart';
import 'state.dart';
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
  CheckInState initialState() => new CheckInState.empty();

  _onUserInput(String userInput) async {
    if( userInput == null || userInput.trim().isEmpty ) {
      setState(new CheckInState.empty());
    }

    final CheckInState state = getState();

    List<Beer> currentPredictions;
    if( state != null && state.currentStatePredictions != null ) {
      currentPredictions = state.currentStatePredictions;
    } else {
      currentPredictions = new List<Beer>(0);
    }

    setState(new CheckInState.searching(currentPredictions));

    try {
      final matchingBeers = await _dataService.findBeersMatching(userInput);
      setState(new CheckInState.predictions(matchingBeers));
    } catch( e, stackTrace ) {
      printException(e, stackTrace, "Error looking for beers matching $userInput");
      setState(new CheckInState.error(e.toString()));
    }
  }

  _onBeerSelected(Beer selectedBeer) async {
    final quantityResult = await showSelectQuantityModal(getBuildContext(), selectedBeer);
    if( quantityResult != null ) {
      pop({
        SELECTED_BEER_KEY: quantityResult.selectedBeer,
        SELECTED_QUANTITY_KEY: quantityResult.quantity,
      });
    }
  }
}