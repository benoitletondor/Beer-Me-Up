import 'dart:async';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'package:beer_me_up/service/userdataservice.dart';
import 'package:beer_me_up/model/checkin.dart';

import 'state.dart';

class HistoryViewModel extends BaseViewModel<HistoryState> {
  final UserDataService _dataService;
  final List<CheckIn> _checkIns = new List();

  HistoryViewModel(
      this._dataService,
      Stream<Null> onErrorRetryButtonPressed,) {

    onErrorRetryButtonPressed.listen(_retryLoading);
  }

  @override
  HistoryState initialState() => new HistoryState.loading();

  @override
  Stream<HistoryState> bind(BuildContext context) {
    _loadData();

    return super.bind(context);
  }

  _loadData() async {
    try {
      setState(new HistoryState.loading());

      final CheckinFetchResponse response = await _dataService.fetchCheckinHistory();
      _checkIns.addAll(response.checkIns);

      setState(new HistoryState.load(await _buildItemList(_checkIns, response.hasMore)));
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

