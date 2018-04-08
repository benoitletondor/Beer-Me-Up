import 'dart:async';
import 'package:meta/meta.dart';

import 'package:flutter/material.dart';

import 'package:beer_me_up/common/mvi/viewstate.dart';
import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/common/widget/beertile.dart';
import 'package:beer_me_up/service/userdataservice.dart';

import 'model.dart';
import 'intent.dart';
import 'state.dart';

const String CHECK_IN_PAGE_ROUTE = "/checkin";
const String SELECTED_BEER_KEY = "selectedBeer";
const String SELECTED_QUANTITY_KEY = "selectedQuantity";

class CheckInPage extends StatefulWidget {
  final CheckInIntent intent;
  final CheckInViewModel model;

  CheckInPage._({
    Key key,
    @required this.intent,
    @required this.model,
  }) : super(key: key);

  factory CheckInPage({
    Key key,
    CheckInIntent intent,
    CheckInViewModel model,
    UserDataService dataService}) {

    final _intent = intent ?? new CheckInIntent();
    final _model = model ?? new CheckInViewModel(
      dataService ?? UserDataService.instance,
      _intent.input,
      _intent.beerSelected,
    );

    return new CheckInPage._(key: key, intent: _intent, model: _model);
  }

  @override
  State<CheckInPage> createState() => new _CheckInPageState(intent: intent, model: model);
}

class _CheckInPageState extends ViewState<CheckInPage, CheckInViewModel, CheckInIntent, CheckInState> {

  _CheckInPageState({
    @required CheckInIntent intent,
    @required CheckInViewModel model
  }): super(intent, model);

  Timer _timer;

  Future<Null> search(String value) async {
    _timer?.cancel();
    _timer = new Timer(const Duration(milliseconds: 300), () {
      _timer.cancel();
      intent.input(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<CheckInState> snapshot) {
        if( !snapshot.hasData ) {
          return new Container();
        }

        return snapshot.data.join(
          (empty) => _buildEmptyScreen(),
          (searching) => _buildLoadingScreen(searching.previousPredictions),
          (predictions) => _buildResultScreen(predictions.predictions),
          (error) => _buildErrorScreen(error.error),
        );
      },
    );
  }

  Widget _buildResultScreen(List<Beer> predictions) {
    return new Scaffold(
      appBar: _buildAppBar(),
      body: new _BeersListView(
        beers: predictions,
        onTap: (beer) => intent.beerSelected(beer),
      ),
    );
  }

  Widget _buildLoadingScreen(List<Beer> previousPrediction) {
    return new Scaffold(
      appBar: _buildAppBar(),
      body: new Stack(
        children: <Widget>[
          new Container(
            constraints: new BoxConstraints(maxHeight: 3.0),
            child: new LinearProgressIndicator()
          ),
          new _BeersListView(
            beers: previousPrediction,
            onTap: intent.beerSelected,
          ),
        ],
      )
    );
  }

  Widget _buildEmptyScreen() {
    return new Scaffold(
      appBar: _buildAppBar(),
      body: new Stack(children: []),
    );
  }

  Widget _buildErrorScreen(String error) {
    return new Scaffold(
      appBar: _buildAppBar(),
      body: new Stack(children: []),
    );
  }

  Widget _buildAppBar() {
    return new AppBar(
      title: new _AppBarPlacesAutoCompleteTextField(
        onInputChanged: (input) => search(input),
      ),
    );
  }
}

class _AppBarPlacesAutoCompleteTextField extends StatelessWidget {
  final ValueChanged<String> onInputChanged;

  _AppBarPlacesAutoCompleteTextField({
    @required this.onInputChanged,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.topLeft,
      margin: new EdgeInsets.only(top: 4.0),
      child: new TextField(
        autofocus: true,
        style: new TextStyle(color: Colors.white70, fontSize: 16.0),
        decoration: new InputDecoration(
          hintText: "Type a beer name",
          hintStyle: new TextStyle(color: Colors.white30, fontSize: 16.0),
          border: null
        ),
        onChanged: (input) => onInputChanged(input),
      ),
    );
  }
}

class _BeersListView extends StatelessWidget {
  final List<Beer> beers;
  final ValueChanged<Beer> onTap;

  _BeersListView({
    @required this.beers,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: beers
        .map((Beer beer) => new BeerTile(
          beer: beer,
          onTap: () { onTap(beer); }
        ))
        .toList()
    );
  }
}