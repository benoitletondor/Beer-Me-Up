import 'dart:async';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'package:beer_me_up/service/userdataservice.dart';
import 'package:beer_me_up/model/checkin.dart';

import 'state.dart';

class HistoryViewModel extends BaseViewModel<HistoryState> {
  final UserDataService _dataService;
  final List<CheckIn> _checkIns = new List();
  List<HistoryListItem> _items = new List();
  bool _hasMore = true;
  StreamSubscription<CheckIn> _checkInSubscription;

  HistoryViewModel(
      this._dataService,
      Stream<Null> onErrorRetryButtonPressed,
      Stream<Null> onLoadMoreButtonPressed,) {

    onErrorRetryButtonPressed.listen(_retryLoading);
    onLoadMoreButtonPressed.listen(_loadMore);
  }

  @override
  HistoryState initialState() => new HistoryState.loading();

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
      setState(new HistoryState.loading());

      final CheckinFetchResponse response = await _dataService.fetchCheckinHistory();
      _checkIns.addAll(response.checkIns);
      _hasMore = response.hasMore;

      _items = await _buildItemList(_checkIns, _hasMore);

      setState(new HistoryState.load(_items));

      _bindToUpdates();
    } catch (e) {
      debugPrint(e.toString());

      setState(new HistoryState.error(e.toString()));
    }
  }

  _retryLoading(Null event) async {
    _loadData();
  }

  Future<List<HistoryListItem>> _buildItemList(List<CheckIn> checkIns, bool hasMore) async {
    final items = new List<HistoryListItem>();
    DateTime lastCheckInDate;

    for(var checkIn in checkIns) {
      final date = new DateTime(checkIn.date.year, checkIn.date.month, checkIn.date.day);
      if( lastCheckInDate != date ) {
        lastCheckInDate = date;
        items.add(new HistoryListSection(date));
      }

      items.add(new HistoryListRow(checkIn));
    }

    if( hasMore ) {
      items.add(new HistoryListLoadMore());
    }

    return items;
  }

  void _bindToUpdates() {
    _checkInSubscription = _dataService.listenForCheckin().listen(_onNewCheckin);
  }

  _onNewCheckin(CheckIn checkIn) async {
    _checkIns.insert(0, checkIn);
    _items = await _buildItemList(_checkIns, _hasMore);

    setState(new HistoryState.load(_items));
  }

  void _loadMore(Null event) async {
    _items.removeLast();
    _items.add(new HistoryListLoading());

    setState(new HistoryState.load(_items));

    try {
      final CheckinFetchResponse response = await _dataService.fetchCheckinHistory(startAfter: _checkIns.last);
      _checkIns.addAll(response.checkIns);
      _hasMore = response.hasMore;

      _items = await _buildItemList(_checkIns, _hasMore);

      setState(new HistoryState.load(_items));
    } catch(e) {
      debugPrint("Error loading more history checkins: $e");

      _items.removeLast();
      _items.add(new HistoryListLoadMore());

      setState(new HistoryState.load(_items));
    }
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

