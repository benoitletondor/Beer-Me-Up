import 'dart:async';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/exceptionprint.dart';
import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'package:beer_me_up/service/userdataservice.dart';
import 'package:beer_me_up/model/beercheckinsdata.dart';
import 'package:beer_me_up/model/beer.dart';

import 'state.dart';

class ProfileViewModel extends BaseViewModel<ProfileState> {
  final UserDataService _dataService;

  ProfileViewModel(
      this._dataService,
      Stream<Null> onErrorRetryButtonPressed,) {

    onErrorRetryButtonPressed.listen(_retryLoading);
  }

  @override
  ProfileState initialState() => new ProfileState.loading();

  @override
  Stream<ProfileState> bind(BuildContext context) {
    _loadData();

    return super.bind(context);
  }

  _loadData() async {
    try {
      setState(new ProfileState.loading());

      final _ProfileData data = await loadProfileData();

      setState(new ProfileState.load(data.favouriteCategory, data.favouriteBeer));
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error loading profile");
      setState(new ProfileState.error(e.toString()));
    }
  }

  _retryLoading(Null event) async {
    _loadData();
  }

  Future<_ProfileData> loadProfileData() async {
    final List<BeerCheckInsData> data = await _dataService.fetchBeerData();

    final Map<BeerCategory, int> categoriesCounter = new Map();

    BeerCheckInsData favouriteBeer;
    BeerCategory favouriteCategory;
    int favouriteCategoryCounter = 0;

    for(BeerCheckInsData checkinData in data) {
      if( favouriteBeer == null || checkinData.drankQuantity > favouriteBeer.drankQuantity ) {
        favouriteBeer = checkinData;
      }

      final category = checkinData.beer.category;
      if( category != null ) {
        categoriesCounter[category] = categoriesCounter.containsKey(category) ? categoriesCounter[category] + 1 : 1;

        final int categoryCount = categoriesCounter[category];
        if( favouriteCategory == null || categoryCount > favouriteCategoryCounter ) {
          favouriteCategory = category;
          favouriteCategoryCounter = categoryCount;
        }
      }
    }

    return new _ProfileData(
      favouriteBeer,
      favouriteCategory
    );
  }
}

class _ProfileData {
  final BeerCategory favouriteCategory;
  final BeerCheckInsData favouriteBeer;

  _ProfileData(this.favouriteBeer, this.favouriteCategory);
}