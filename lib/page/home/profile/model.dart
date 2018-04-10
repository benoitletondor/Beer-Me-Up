import 'dart:async';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/exceptionprint.dart';
import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'package:beer_me_up/service/userdataservice.dart';
import 'package:beer_me_up/model/beercheckinsdata.dart';
import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/model/checkin.dart';

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

      final ProfileData data = await loadProfileData();

      setState(new ProfileState.load(data));
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error loading profile");
      setState(new ProfileState.error(e.toString()));
    }
  }

  _retryLoading(Null event) async {
    _loadData();
  }

  Future<ProfileData> loadProfileData() async {
    final List<BeerCheckInsData> data = await _dataService.fetchBeerData();
    final List<CheckIn> checkIns = await _dataService.fetchThisWeekCheckIns();

    return ProfileData.fromData(data, checkIns);
  }
}

class ProfileData {
  final BeerCategory favouriteCategory;
  final BeerCheckInsData favouriteBeer;

  final List<BeerCheckInsData> weekBeers;
  final double weekDrankQuantity;

  ProfileData(this.favouriteBeer, this.favouriteCategory, this.weekBeers, this.weekDrankQuantity);

  factory ProfileData.fromData(List<BeerCheckInsData> checkInsData, List<CheckIn> checkIns) {
    final Map<BeerCategory, int> categoriesCounter = new Map();

    BeerCheckInsData favouriteBeer;
    BeerCategory favouriteCategory;
    int favouriteCategoryCounter = 0;

    for(BeerCheckInsData checkinData in checkInsData) {
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

    final Map<Beer, BeerCheckInsData> weekBeersMap = new Map();
    double weekDrankQuantity = 0.0;

    for(CheckIn checkin in checkIns) {
      BeerCheckInsData data = weekBeersMap[checkin.beer];

      weekBeersMap[checkin.beer] = new BeerCheckInsData(
        checkin.beer,
        (data == null ? 0 : data.numberOfCheckIns) + 1,
        data == null ? checkin.date : (data.lastCheckinTime.isBefore(checkin.date) ? checkin.date : data.lastCheckinTime),
        (data == null ? 0.0 : data.drankQuantity) + checkin.quantity.value,
      );

      weekDrankQuantity += checkin.quantity.value;
    }
    
    final List<BeerCheckInsData> checkInsList =  weekBeersMap.values.toList(growable: false);
    checkInsList.sort((a, b) => b.drankQuantity.compareTo(a.drankQuantity));

    return new ProfileData(
      favouriteBeer,
      favouriteCategory,
      checkInsList,
      weekDrankQuantity,
    );
  }
}
