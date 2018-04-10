import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/model/checkin.dart';
import 'package:beer_me_up/common/mvi/viewstate.dart';
import 'package:beer_me_up/common/widget/beertile.dart';

import 'model.dart';
import 'intent.dart';
import 'state.dart';

const String CHECK_IN_QUANTITY_PAGE_ROUTE = "/checkin/quantity";
const String SELECTED_CHECKIN_QUANTITY_KEY = "selectedQuantity";

class CheckInQuantityPage extends StatefulWidget {
  final CheckInQuantityIntent intent;
  final CheckInQuantityViewModel model;

  CheckInQuantityPage._({
    Key key,
    @required this.intent,
    @required this.model,
  }) : super(key: key);

  factory CheckInQuantityPage({
    Key key,
    @required Beer selectedBeer,
    CheckInQuantityIntent intent,
    CheckInQuantityViewModel model}) {

    final _intent = intent ?? new CheckInQuantityIntent();
    final _model = model ?? new CheckInQuantityViewModel(
      selectedBeer,
      _intent.quantitySelected,
      _intent.checkInConfirmed,
    );

    return new CheckInQuantityPage._(key: key, intent: _intent, model: _model);
  }

  @override
  State<CheckInQuantityPage> createState() => new _CheckInQuantityPageState(intent: intent, model: model);
}

class _CheckInQuantityPageState extends ViewState<CheckInQuantityPage, CheckInQuantityViewModel, CheckInQuantityIntent, CheckInQuantityState> {

  _CheckInQuantityPageState({
    @required CheckInQuantityIntent intent,
    @required CheckInQuantityViewModel model
  }) : super(intent, model);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<CheckInQuantityState> snapshot) {
        if (!snapshot.hasData) {
          return new Container();
        }

        return snapshot.data.join(
          (base) => _buildBaseScreen(base.selectedBeer),
          (quantitySelected) => _buildQuantitySelectedScreen(quantitySelected.selectedBeer, quantitySelected.quantity),
          (error) => _buildErrorScreen(error.selectedBeer),
        );
      },
    );
  }

  Widget _buildBaseScreen(Beer selectedBeer) => _buildScreen(selectedBeer, null, false);

  Widget _buildQuantitySelectedScreen(Beer selectedBeer, CheckInQuantity quantity) => _buildScreen(selectedBeer, quantity, false);

  Widget _buildErrorScreen(Beer selectedBeer) => _buildScreen(selectedBeer, null, true);

  Widget _buildScreen(Beer selectedBeer, CheckInQuantity selectedQuantity, bool error) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Confirm checkin'),
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            new Padding(padding: EdgeInsets.only(top: 20.0)),
            new BeerTile(beer: selectedBeer),
            new Padding(padding: EdgeInsets.only(top: 20.0)),
            new Center(
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: _buildQuantityTiles(selectedQuantity),
              ),
            ),
            new Padding(padding: new EdgeInsets.only(top: 20.0)),
            new Offstage(
              offstage: !error,
              child: new Text(
                "Please select a quantity to confirm checkin",
                style: new TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            new Padding(padding: new EdgeInsets.only(top: 20.0)),
            new RaisedButton(
              onPressed: intent.checkInConfirmed,
              color: Theme.of(context).accentColor,
              child: new Text(
                "Confirm \"${selectedBeer.name}\" checkin",
                style: new TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildQuantityTiles(CheckInQuantity selectedQuantity) {
    final List<Widget> tiles = new List();

    for(CheckInQuantity quantity in CheckInQuantity.values) {
      tiles.add(_buildQuantityTile(quantity, selectedQuantity == quantity));
    }

    return tiles;
  }

  Widget _buildQuantityTile(CheckInQuantity quantity, bool isSelected) {
    return new Container(
      padding: EdgeInsets.only(left: 5.0, right: 5.0),
      child: new GestureDetector(
        onTap: () { intent.quantitySelected(quantity); },
        child: new Container(
          padding: EdgeInsets.all(5.0),
          child: new Column(
            children: <Widget>[
              new Icon(const IconData(0xe901, fontFamily: "beers")),
              new Text(_getTextForQuantity(quantity)),
            ],
          ),
          decoration: new BoxDecoration(
            border: new Border.all(width: 2.0, color: isSelected ? Colors.lightGreen[700] : Colors.grey[600]),
            borderRadius: new BorderRadius.all(const Radius.circular(4.0)),
          ),
        ),
      ),
    );
  }

  String _getTextForQuantity(CheckInQuantity quantity) {
    switch(quantity) {
      case CheckInQuantity.BOTTLE:
        return "Bottle (0.33l)";
      case CheckInQuantity.HALF_PINT:
        return "Half Pint(0.25l)";
      case CheckInQuantity.PINT:
        return "Pint (0.5l)";
    }

    return "Unknown";
  }

}
