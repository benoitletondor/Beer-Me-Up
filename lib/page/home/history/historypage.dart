import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/widget/loadingwidget.dart';
import 'package:beer_me_up/common/widget/erroroccurredwidget.dart';
import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/service/userdataservice.dart';
import 'package:beer_me_up/common/mvi/viewstate.dart';

import 'model.dart';
import 'intent.dart';
import 'state.dart';

class HistoryPage extends StatefulWidget {
  final HistoryIntent intent;
  final HistoryViewModel model;

  HistoryPage._({
    Key key,
    @required this.intent,
    @required this.model,
  }) : super(key: key);

  factory HistoryPage({Key key,
    HistoryIntent intent,
    HistoryViewModel model,
    UserDataService dataService}) {

    final _intent = intent ?? new HistoryIntent();
    final _model = model ?? new HistoryViewModel(
      dataService ?? UserDataService.instance,
      _intent.retry,
    );

    return new HistoryPage._(key: key, intent: _intent, model: _model);
  }

  @override
  _HistoryPageState createState() => new _HistoryPageState(intent: intent, model: model);
}

class _HistoryPageState extends ViewState<HistoryPage, HistoryViewModel, HistoryIntent, HistoryState> {

  _HistoryPageState({
    @required HistoryIntent intent,
    @required HistoryViewModel model
  }): super(intent, model);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<HistoryState> snapshot) {
        if( !snapshot.hasData ) {
          return new Container();
        }

        return snapshot.data.join(
          (loading) => _buildLoadingWidget(),
          (load) => _buildLoadWidget(beers: load.beers),
          (error) => _buildErrorWidget(error: error.error),
        );
      },
    );
  }

  Widget _buildLoadingWidget() {
    return new LoadingWidget();
  }

  Widget _buildErrorWidget({@required String error}) {
    return new ErrorOccurredWidget(
        error,
            () { intent.retry(); }
    );
  }

  Widget _buildLoadWidget({List<Beer> beers}) {
    return new Text("Beers: ${beers.length}");
  }
}