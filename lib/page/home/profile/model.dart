import 'dart:async';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/exceptionprint.dart';
import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'package:beer_me_up/service/userdataservice.dart';
import 'package:beer_me_up/model/beercheckinsdata.dart';
import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/model/checkin.dart';
import 'package:beer_me_up/common/datehelper.dart';

import 'state.dart';

class ProfileViewModel extends BaseViewModel<ProfileState> {
  final UserDataService _dataService;

  List<BeerCheckInsData> _checkInsData;
  List<CheckIn> _checkIns;
  int _totalPoints;

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

      await _loadProfileData();

      _setStateWithProfileData(await _buildProfileData());

      _bindToUpdates();
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error loading profile");
      setState(ProfileState.error(e.toString()));
    }
  }

  _retryLoading(Null event) async {
    _loadData();
  }

  _loadProfileData() async {
    _checkInsData = List.from(await _dataService.fetchBeerCheckInsData());
    _checkIns = List.from(await _dataService.fetchThisWeekCheckIns());
    _totalPoints = await _dataService.getTotalUserPoints();
  }

  Future<ProfileData> _buildProfileData() async {
    return ProfileData.fromData(_totalPoints, _checkInsData, _checkIns);
  }

  void _bindToUpdates() {
    _checkInSubscription?.cancel();
    _checkInSubscription = _dataService.listenForCheckIn().listen((checkIn) {
      _handleCheckIn(checkIn);
    });
  }

  void _handleCheckIn(CheckIn checkIn) async {
    setState(ProfileState.loading());

    try {
      final weekDate = getWeekStartAndEndDate(DateTime.now());
      if( checkIn.date.isAfter(weekDate.item1) && checkIn.date.isBefore(weekDate.item2) ) {
        _checkIns.add(checkIn);
      }

      int dataIndex = _checkInsData.indexWhere((checkInData) => checkInData.beer == checkIn.beer);
      if( dataIndex < 0 ) {
        _checkInsData.add(BeerCheckInsData(checkIn.beer, 1, checkIn.date, checkIn.quantity.value));
      } else {
        final currentData = _checkInsData[dataIndex];
        _checkInsData.removeAt(dataIndex);

        _checkInsData.add(BeerCheckInsData(
          checkIn.beer,
          currentData.numberOfCheckIns + 1,
          checkIn.date.isAfter(currentData.lastCheckinTime) ? checkIn.date : currentData.lastCheckinTime,
          currentData.drankQuantity + checkIn.quantity.value,
        ));
      }

      _totalPoints += checkIn.points;

      _setStateWithProfileData(await _buildProfileData());
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error updating profile");
      setState(ProfileState.error(e.toString()));
    }
  }

  _setStateWithProfileData(ProfileData profileData) {
    if( !profileData.hasAllTime && !profileData.hasWeek ) {
      setState(ProfileState.empty());
    } else if( profileData.hasWeek && profileData.hasAllTime ) {
      setState(ProfileState.load(profileData));
    } else if( profileData.hasAllTime ) {
      setState(ProfileState.loadNoWeek(profileData));
    } else {
      setState(ProfileState.loadNoAllTime(profileData));
    }
  }
}

class ProfileData {
  final bool hasAllTime;
  final bool hasWeek;

  final BeerCategory favouriteCategory;
  final BeerCheckInsData favouriteBeer;
  final int totalPoints;

  final List<BeerCheckInsData> weekBeers;
  final int numberOfBeers;
  final int weekPoints;

  ProfileData(this.hasAllTime, this.hasWeek, this.favouriteBeer, this.favouriteCategory, this.weekBeers, this.numberOfBeers, this.weekPoints, this.totalPoints);

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
      checkInsData.length >= 3,
      checkIns.isNotEmpty,
      favouriteBeer,
      favouriteCategory,
      checkInsList,
      weekBeersMap.length,
      points,
      totalPoints,
    );
  }
}
