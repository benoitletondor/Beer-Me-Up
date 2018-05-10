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

  StreamSubscription<CheckIn> _checkInSubscription;

  ProfileViewModel(
      this._dataService,
      Stream<Null> onErrorRetryButtonPressed,) {

    onErrorRetryButtonPressed.listen(_retryLoading);
  }

  @override
  ProfileState initialState() => ProfileState.loading();

  @override
  Stream<ProfileState> bind(BuildContext context) {
    _loadData();

    return super.bind(context);
  }

  @override
  unbind() {
    _checkInSubscription?.cancel();
    _checkInSubscription = null;

    super.unbind();
  }

  _loadData() async {
    try {
      setState(ProfileState.loading());

      final ProfileData data = await loadProfileData();

      setState(ProfileState.load(data));

      _bindToUpdates();
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error loading profile");
      setState(ProfileState.error(e.toString()));
    }
  }

  _retryLoading(Null event) async {
    _loadData();
  }

  Future<ProfileData> loadProfileData() async {
    final List<BeerCheckInsData> data = await _dataService.fetchBeerCheckInsData();
    final List<CheckIn> checkIns = await _dataService.fetchThisWeekCheckIns();
    final int totalPoints = await _dataService.getTotalUserPoints();

    return ProfileData.fromData(totalPoints, data, checkIns);
  }

  void _bindToUpdates() {
    _checkInSubscription?.cancel();
    _checkInSubscription = _dataService.listenForCheckIn().listen((checkIn) {
      _loadData();
    });
  }
}

class ProfileData {
  final BeerCategory favouriteCategory;
  final BeerCheckInsData favouriteBeer;
  final int totalPoints;

  final List<BeerCheckInsData> weekBeers;
  final int numberOfBeers;
  final int weekPoints;

  ProfileData(this.favouriteBeer, this.favouriteCategory, this.weekBeers, this.numberOfBeers, this.weekPoints, this.totalPoints);

  factory ProfileData.fromData(int totalPoints, List<BeerCheckInsData> checkInsData, List<CheckIn> checkIns) {
    final Map<BeerCategory, double> categoriesCounter = Map();

    BeerCheckInsData favouriteBeer;
    BeerCategory favouriteCategory;
    double favouriteCategoryCounter = 0.0;

    for(BeerCheckInsData checkinData in checkInsData) {
      if( favouriteBeer == null || checkinData.drankQuantity > favouriteBeer.drankQuantity ) {
        favouriteBeer = checkinData;
      }

      final category = checkinData.beer.category;
      if( category != null ) {
        categoriesCounter[category] = categoriesCounter.containsKey(category) ? categoriesCounter[category] + checkinData.drankQuantity : checkinData.drankQuantity;

        final double categoryCount = categoriesCounter[category];
        if( favouriteCategory == null || categoryCount > favouriteCategoryCounter ) {
          favouriteCategory = category;
          favouriteCategoryCounter = categoryCount;
        }
      }
    }

    final Map<String, BeerCheckInsData> weekBeersMap = Map();
    int points = 0;

    for(CheckIn checkin in checkIns) {
      BeerCheckInsData data = weekBeersMap[checkin.beer.id];

      weekBeersMap[checkin.beer.id] = BeerCheckInsData(
        checkin.beer,
        (data == null ? 0 : data.numberOfCheckIns) + 1,
        data == null ? checkin.date : (data.lastCheckinTime.isBefore(checkin.date) ? checkin.date : data.lastCheckinTime),
        (data == null ? 0.0 : data.drankQuantity) + checkin.quantity.value,
      );

      points += checkin.points;
    }
    
    final List<BeerCheckInsData> checkInsList = weekBeersMap.values.toList(growable: false);
    checkInsList.sort((a, b) => b.drankQuantity.compareTo(a.drankQuantity));

    return ProfileData(
      favouriteBeer,
      favouriteCategory,
      checkInsList,
      weekBeersMap.length,
      points,
      totalPoints,
    );
  }
}
