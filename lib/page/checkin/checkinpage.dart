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
const String SELECTED_DATE_KEY = "selectedDate";
const String POINTS_KEY = "points";

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

    final _intent = intent ?? CheckInIntent();
    final _model = model ?? CheckInViewModel(
      dataService ?? UserDataService.instance,
      _intent.input,
      _intent.beerSelected,
    );

    return CheckInPage._(key: key, intent: _intent, model: _model);
  }

  @override
  State<CheckInPage> createState() => _CheckInPageState(intent: intent, model: model);
}

class _CheckInPageState extends ViewState<CheckInPage, CheckInViewModel, CheckInIntent, CheckInState> {

  _CheckInPageState({
    @required CheckInIntent intent,
    @required CheckInViewModel model
  }): super(intent, model);

  Timer _timer;

  Future<Null> _search(String value) async {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: 600), () {
      _timer.cancel();
      intent.input(value);
    });
  }

  _validateSearch(String value) {
    _timer?.cancel();
    intent.input(value);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<CheckInState> snapshot) {
        if( !snapshot.hasData ) {
          return Container();
        }

        return snapshot.data.join(
          (empty) => _buildEmptyScreen(),
          (searching) => _buildLoadingScreen(searching.previousPredictions),
          (predictions) => _buildResultScreen(predictions.predictions),
          (noPredictions) => _buildEmptyResultScreen(),
          (error) => _buildErrorScreen(error.error),
        );
      },
    );
  }

  Widget _buildResultScreen(List<Beer> predictions) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _BeersListView(
        beers: predictions,
        onTap: (beer) => intent.beerSelected(beer),
      ),
    );
  }

  Widget _buildEmptyResultScreen() {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(children: []),
    );
  }

  Widget _buildLoadingScreen(List<Beer> previousPrediction) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: <Widget>[
          Container(
            constraints: const BoxConstraints(maxHeight: 3.0),
            child: const LinearProgressIndicator()
          ),
          _BeersListView(
            beers: previousPrediction,
            onTap: intent.beerSelected,
          ),
        ],
      )
    );
  }

  Widget _buildEmptyScreen() {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(children: []),
    );
  }

  Widget _buildErrorScreen(String error) {
    // TODO
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(children: []),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: _AppBarPlacesAutoCompleteTextField(
        onInputChanged: (input) => _search(input),
        onInputSubmitted: (input) => _validateSearch(input),
      ),
    );
  }
}

class _AppBarPlacesAutoCompleteTextField extends StatelessWidget {
  final ValueChanged<String> onInputChanged;
  final ValueChanged<String> onInputSubmitted;

  _AppBarPlacesAutoCompleteTextField({
    @required this.onInputChanged,
    @required this.onInputSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextField(
        autofocus: true,
        maxLines: 1,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0
        ),
        decoration: const InputDecoration(
          hintText: "Type a beer name",
          hintStyle: const TextStyle(color: Color(0x99FFFFFF), fontSize: 16.0),
          border: InputBorder.none,
        ),
        onChanged: (input) => onInputChanged(input),
        onSubmitted: (input) => onInputSubmitted(input),
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
    return ListView.builder(
      itemCount: beers.length,
      itemBuilder: (BuildContext context, int index) {
        final Beer beer = beers[index];

        return BeerTile(
          beer: beer,
          title: beer.name,
          subtitle: beer.style?.shortName,
          onTap: () { onTap(beer); }
        );
      },
    );
  }
}