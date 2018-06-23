import 'dart:async';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'package:beer_me_up/service/userdataservice.dart';
import 'package:beer_me_up/model/checkin.dart';
import 'package:beer_me_up/common/exceptionprint.dart';

import 'state.dart';

class CheckInDisplayViewModel extends BaseViewModel<CheckInDisplayState> {
  final UserDataService _dataService;
  final CheckIn _checkIn;

  CheckInDisplayViewModel(
      this._dataService,
      this._checkIn,
      Stream<int> onRatingPressed,
      Stream<Null> onRetryLoadingPressed,) {

    onRatingPressed.listen(_rate);
    onRetryLoadingPressed.listen(_retryLoading);
  }

  @override
  Stream<CheckInDisplayState> bind(BuildContext context) {
    _loadRating();

    return super.bind(context);
  }

  @override
  CheckInDisplayState initialState() => CheckInDisplayState.loading(_checkIn);

  _loadRating() async {
    setState(CheckInDisplayState.loading(_checkIn));

    try {
      final int rating = await _dataService.fetchRatingForBeer(_checkIn.beer);

      setState(CheckInDisplayState.load(_checkIn, rating));
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error fetching rating");

      setState(CheckInDisplayState.error(_checkIn, "An error occurred while getting your rating: ${e.toString()}"));
    }
  }

  _rate(int rating) async {
    setState(CheckInDisplayState.loading(_checkIn));

    try {
      await _dataService.saveRatingForBeer(_checkIn.beer, rating);

      setState(CheckInDisplayState.load(_checkIn, rating));
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error setting rating");

      setState(CheckInDisplayState.error(_checkIn, "An error occurred while rating the beer: ${e.toString()}"));
    }
  }

  _retryLoading(Null event) async {
    _loadRating();
  }
}