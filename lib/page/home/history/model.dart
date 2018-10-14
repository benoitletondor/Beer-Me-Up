import 'dart:async';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/exceptionprint.dart';
import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'package:beer_me_up/service/userdataservice.dart';
import 'package:beer_me_up/page/rating/ratingpage.dart';
import 'package:beer_me_up/model/checkin.dart';

import 'state.dart';

class HistoryViewModel extends BaseViewModel<HistoryState> {
  final UserDataService _dataService;
  final List<CheckIn> _checkIns = List();
  List<HistoryListItem> _items = List();
  bool _hasMore = true;
  StreamSubscription<CheckIn> _checkInSubscription;

  HistoryViewModel(
      this._dataService,
      Stream<Null> onErrorRetryButtonPressed,
      Stream<Null> onLoadMoreButtonPressed,
      Stream<CheckIn> onCheckInPressed,) {

    onErrorRetryButtonPressed.listen(_retryLoading);
    onLoadMoreButtonPressed.listen(_loadMore);
    onCheckInPressed.listen(_checkInPressed);
  }

  @override
  HistoryState initialState() => HistoryState.loading();

  @override
  Stream<HistoryState> bind(BuildContext context) {
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
      setState(HistoryState.loading());

      final CheckinFetchResponse response = await _dataService.fetchCheckInHistory();
      _checkIns.addAll(response.checkIns);
      _hasMore = response.hasMore;

      _items = await _buildItemList(_checkIns, _hasMore);

      if( _items.isEmpty ) {
        setState(HistoryState.empty());
      } else {
        setState(HistoryState.load(_items));
      }

      _bindToUpdates();
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error loading history");
      setState(HistoryState.error(e.toString()));
    }
  }

  _retryLoading(Null event) async {
    _loadData();
  }

  Future<List<HistoryListItem>> _buildItemList(List<CheckIn> checkIns, bool hasMore) async {
    final items = List<HistoryListItem>();
    DateTime lastCheckInDate;

    for(var checkIn in checkIns) {
      final date = DateTime(checkIn.date.year, checkIn.date.month, checkIn.date.day);
      if( lastCheckInDate != date ) {
        lastCheckInDate = date;
        items.add(HistoryListSection(date));
      }

      items.add(HistoryListRow(checkIn));
    }

    if( hasMore ) {
      items.add(HistoryListLoadMore());
    }

    return items;
  }

  void _bindToUpdates() {
    _checkInSubscription?.cancel();
    _checkInSubscription = _dataService.listenForCheckIn().listen(_onNewCheckin);
  }

  _onNewCheckin(CheckIn checkIn) async {
    if( _checkIns.isNotEmpty && _checkIns[0].date.isAfter(checkIn.date) ) {
      _checkIns.add(checkIn);
      _checkIns.sort((a, b) => b.date.compareTo(a.date));
    } else {
      _checkIns.insert(0, checkIn);
    }

    _items = await _buildItemList(_checkIns, _hasMore);

    setState(HistoryState.load(_items));
  }

  void _loadMore(Null event) async {
    _items.removeLast();
    _items.add(HistoryListLoading());

    setState(HistoryState.load(_items));

    try {
      final CheckinFetchResponse response = await _dataService.fetchCheckInHistory(startAfter: _checkIns.last);
      _checkIns.addAll(response.checkIns);
      _hasMore = response.hasMore;

      _items = await _buildItemList(_checkIns, _hasMore);

      setState(HistoryState.load(_items));
    } catch(e, stackTrace) {
      printException(e, stackTrace, "Error loading more history checkins");

      _items.removeLast();
      _items.add(HistoryListLoadMore());

      setState(HistoryState.load(_items));
    }
  }

  _checkInPressed(CheckIn checkIn) async {
    pushRoute(
      MaterialPageRoute(
        builder: (BuildContext context) => RatingPage(beer: checkIn.beer),
      )
    );
  }
}

abstract class HistoryListItem {}

class HistoryListSection extends HistoryListItem {
  final DateTime date;

  HistoryListSection(this.date);
}

class HistoryListRow extends HistoryListItem {
  final CheckIn checkIn;

  HistoryListRow(this.checkIn);
}

class HistoryListLoadMore extends HistoryListItem {}

class HistoryListLoading extends HistoryListItem {}

