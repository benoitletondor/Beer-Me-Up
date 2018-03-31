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

      setState(new HistoryState.load(_checkIns, response.hasMore));
    } catch (e) {
      debugPrint(e.toString());

      setState(new HistoryState.error(e.toString()));
    }
  }

  _retryLoading(Null event) async {
    _loadData();
  }
}