import 'dart:async';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'package:beer_me_up/service/userdataservice.dart';
import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/common/exceptionprint.dart';

import 'state.dart';

class RatingViewModel extends BaseViewModel<RatingState> {
  final UserDataService _dataService;
  final Beer _beer;

  RatingViewModel(
      this._dataService,
      this._beer,
      Stream<int> onRatingPressed,
      Stream<Null> onRetryLoadingPressed,) {

    onRatingPressed.listen(_rate);
    onRetryLoadingPressed.listen(_retryLoading);
  }

  @override
  Stream<RatingState> bind(BuildContext context) {
    _loadRating();

    return super.bind(context);
  }

  @override
  RatingState initialState() => RatingState.loading(_beer);

  _loadRating() async {
    setState(RatingState.loading(_beer));

    try {
      final int rating = await _dataService.fetchRatingForBeer(_beer);

      setState(RatingState.load(_beer, rating));
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error fetching rating");

      setState(RatingState.error(_beer, "An error occurred while getting your rating: ${e.toString()}"));
    }
  }

  _rate(int rating) async {
    setState(RatingState.loading(_beer));

    try {
      await _dataService.saveRatingForBeer(_beer, rating);

      setState(RatingState.load(_beer, rating));
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error setting rating");

      setState(RatingState.error(_beer, "An error occurred while rating the beer: ${e.toString()}"));
    }
  }

  _retryLoading(Null event) async {
    _loadRating();
  }
}