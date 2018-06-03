import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'state.dart';
import 'checkinconfirmpage.dart';
import 'package:beer_me_up/model/checkin.dart';
import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/service/userdataservice.dart';
import 'package:beer_me_up/common/exceptionprint.dart';
import 'package:beer_me_up/service/config.dart';

class CheckInConfirmViewModel extends BaseViewModel<CheckInConfirmState> {
  final UserDataService _userDateService;
  final Config _config;
  final Beer selectedBeer;
  DateTime date = new DateTime.now();
  CheckInQuantity quantity;
  CheckinPoints points;
  String error;

  CheckInConfirmViewModel(
      this.selectedBeer,
      this._userDateService,
      this._config,
      Stream<CheckInQuantity> onQuantitySelected,
      Stream<Null> onCheckInConfirmed,
      Stream<Null> changeDateTimeClicked,
      Stream<Null> retryButtonClicked) {

    onQuantitySelected.listen(_onQuantitySelected);
    onCheckInConfirmed.listen(_onCheckInConfirmed);
    changeDateTimeClicked.listen(_onChangeDateTimeClicked);
    retryButtonClicked.listen(_onRetryButtonClicked);
  }


  @override
  Stream<CheckInConfirmState> bind(BuildContext context) {
    _loadPoints();

    return super.bind(context);
  }

  @override
  CheckInConfirmState initialState() => CheckInConfirmState.loading(selectedBeer, date, quantity);

  _onQuantitySelected(CheckInQuantity quantity) async {
    this.quantity = quantity;

    _setCurrentState();
  }

  _onChangeDateTimeClicked(Null event) async {
    this.date = await showDateTimePicker(getBuildContext(), date);

    _loadPoints();
  }

  _onCheckInConfirmed(Null event) async {
    if( quantity == null ) {
      setState(CheckInConfirmState.quantityNotSelected(selectedBeer, date, points));
      return;
    }

    if( points == null ) {
      _setCurrentState();
      return;
    }

    pop({
      SELECTED_CHECKIN_QUANTITY_KEY: quantity,
      SELECTED_CHECKIN_DATE_KEY: date,
      CHECKIN_POINTS_KEY: points.total,
    });
  }

  _onRetryButtonClicked(Null event) async {
    _loadPoints();
  }

// -------------------------------------->

  _loadPoints() async {
    error = null;
    points = null;

    setState(CheckInConfirmState.loading(selectedBeer, date, quantity));

    try {
      points = await _buildPoints(selectedBeer, await _userDateService.getCheckinDetails(selectedBeer, date));

      setState(CheckInConfirmState.load(selectedBeer, quantity, date, points));
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error fetching points");
      error = e.toString();
      points = null;

      setState(CheckInConfirmState.errorFetchingPoints(selectedBeer, date, quantity, error));
    }
  }

  _setCurrentState() {
    if( points != null ) {
      setState(CheckInConfirmState.load(selectedBeer, quantity, date, points));
    } else if (error != null) {
      setState(CheckInConfirmState.errorFetchingPoints(selectedBeer, date, quantity, error));
    } else {
      setState(CheckInConfirmState.loading(selectedBeer, date, quantity));
    }
  }

  Future<CheckinPoints> _buildPoints(Beer selectedBeer, CheckinDetails checkinDetails) async {
    List<CheckinPointsDetail> pointsDetails = List();

    if( !checkinDetails.beerAlreadyCheckedIn ) {
      pointsDetails.add(CheckinPointsDetail(_config.getFirstBeerCheckInPoints(), PointType.FIRST_BEER_CHECKIN));
    }

    bool categoryAlreadyCheckedInThisWeek = false;
    bool beerAlreadyCheckedInThisWeek = false;

    if( selectedBeer.style == null ) {
      categoryAlreadyCheckedInThisWeek = true;
    }

    checkinDetails.weekCheckIns.forEach((checkin) {
      if( checkin.beer.id == selectedBeer.id ) {
        beerAlreadyCheckedInThisWeek = true;
      }

      if( checkin.beer.style?.id == selectedBeer.style?.id ) {
        categoryAlreadyCheckedInThisWeek = true;
      }
    });

    if( checkinDetails.weekCheckIns.isEmpty ) {
      pointsDetails.add(CheckinPointsDetail(_config.getFirstWeekCheckInPoints(), PointType.FIRST_WEEK_CHECKIN));
    }

    if( !beerAlreadyCheckedInThisWeek ) {
      pointsDetails.add(CheckinPointsDetail(_config.getFirstWeekBeerCheckInPoints(), PointType.FIRST_WEEK_BEER_CHECKIN));
    }

    if( !categoryAlreadyCheckedInThisWeek ) {
      pointsDetails.add(CheckinPointsDetail(_config.getFirstWeekCategoryCheckInPoints(), PointType.FIRST_WEEK_CATEGORY_CHECKIN));
    }

    if( pointsDetails.isEmpty ) {
      pointsDetails.add(CheckinPointsDetail(_config.getDefaultCheckInPoints(), PointType.DEFAULT));
    }

    pointsDetails.sort();

    int total = 0;
    pointsDetails.forEach((detail) {
      total += detail.points;
    });

    return CheckinPoints(total, pointsDetails);
  }
}

class CheckinPoints {
  final int total;
  final List<CheckinPointsDetail> details;

  CheckinPoints(this.total, this.details);
}

class CheckinPointsDetail implements Comparable<CheckinPointsDetail> {
  final int points;
  final PointType type;

  CheckinPointsDetail(this.points, this.type);

  @override
  int compareTo(CheckinPointsDetail other) {
    return other.points.compareTo(points);
  }
}

enum PointType {
  DEFAULT,
  FIRST_BEER_CHECKIN,
  FIRST_WEEK_CHECKIN,
  FIRST_WEEK_BEER_CHECKIN,
  FIRST_WEEK_CATEGORY_CHECKIN
}