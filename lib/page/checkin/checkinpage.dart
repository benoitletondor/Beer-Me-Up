import 'dart:async';
import 'package:meta/meta.dart';

import 'package:flutter/material.dart';

import 'package:beer_me_up/common/mvi/viewstate.dart';
import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/common/widget/beertile.dart';
import 'package:beer_me_up/service/userdataservice.dart';
import 'package:beer_me_up/common/widget/erroroccurredwidget.dart';
import 'package:beer_me_up/localization/localization.dart';

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
    _timer = Timer(Duration(milliseconds: 700), () {
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
          (emptyLastBeers) => _buildEmptyScreenWithLastBeers(emptyLastBeers.beers),
          (searching) => _buildEmptyLoadingScreen(),
          (searchingWithPredictions) => _buildLoadingScreen(searchingWithPredictions.previousPredictions),
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Opacity(
                opacity: 0.6,
                child: Image.asset(
                  "images/search_empty_state.png",
                  width: 100.0,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 16.0)),
              Text(
                Localization.of(context).checkInEmptyResult,
                style: const TextStyle(
                  color: Colors.black38,
                  fontFamily: "Google Sans",
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
              const Padding(padding: EdgeInsets.only(top: 16.0)),
              Text(
                Localization.of(context).checkInEmptyResultAdvice,
                style: const TextStyle(
                  color: Colors.black38,
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyLoadingScreen() {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        constraints: const BoxConstraints(maxHeight: 3.0),
        child: const LinearProgressIndicator(),
      ),
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
      body: Container(),
    );
  }

  Widget _buildEmptyScreenWithLastBeers(List<Beer> beers) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _BeersListView(
        beers: beers,
        onTap: (beer) => intent.beerSelected(beer),
        header: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0, top: 20.0),
          child: Text(
            Localization.of(context).checkInEmptyHistoryHeader,
            style: const TextStyle(
              fontSize: 17.0,
              fontFamily: "Google Sans",
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(String error) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ErrorOccurredWidget(error: error),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: _AppBarPlacesAutoCompleteTextField(
        onInputChanged: _search,
        onInputSubmitted: _validateSearch,
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
        decoration: InputDecoration(
          hintText: Localization.of(context).checkInHint,
          hintStyle: const TextStyle(color: Color(0x99FFFFFF), fontSize: 16.0),
          border: InputBorder.none,
        ),
        onChanged: onInputChanged,
        onSubmitted: onInputSubmitted,
      ),
    );
  }
}

class _BeersListView extends StatelessWidget {
  final Widget header;
  final List<Beer> beers;
  final ValueChanged<Beer> onTap;

  _BeersListView({
    @required this.beers,
    this.onTap,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: beers.length + 1 + (this.header == null ? 0 : 1),
            itemBuilder: (BuildContext context, int index) {
              if( index == 0 && this.header != null ) {
                return this.header;
              }

              if( index == beers.length + (this.header == null ? 0 : 1)) {
                return const _BeerContentProviderAttributionWidget();
              }

              final Beer beer = beers[index - (this.header == null ? 0 : 1)];

              return BeerTile(
                beer: beer,
                title: beer.name,
                subtitle: beer.style?.name,
                onTap: () { onTap(beer); }
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BeerContentProviderAttributionWidget extends StatelessWidget {
  const _BeerContentProviderAttributionWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      constraints: const BoxConstraints(maxHeight: 50.0),
      child: Center(
        child: Image.asset("images/untappd.png"),
      ),
    );
  }

}