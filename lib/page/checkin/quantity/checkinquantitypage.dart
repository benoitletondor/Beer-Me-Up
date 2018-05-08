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

    final _intent = intent ?? CheckInQuantityIntent();
    final _model = model ?? CheckInQuantityViewModel(
      selectedBeer,
      _intent.quantitySelected,
      _intent.checkInConfirmed,
    );

    return CheckInQuantityPage._(key: key, intent: _intent, model: _model);
  }

  @override
  State<CheckInQuantityPage> createState() => _CheckInQuantityPageState(intent: intent, model: model);
}

class _CheckInQuantityPageState extends ViewState<CheckInQuantityPage, CheckInQuantityViewModel, CheckInQuantityIntent, CheckInQuantityState> {

  _CheckInQuantityPageState({
    @required CheckInQuantityIntent intent,
    @required CheckInQuantityViewModel model
  }) : super(intent, model);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<CheckInQuantityState> snapshot) {
        if (!snapshot.hasData) {
          return Container();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm checkin'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 20.0)),
            BeerTile(beer: selectedBeer, title: selectedBeer.name),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: _buildQuantityTiles(selectedQuantity),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Offstage(
              offstage: !error,
              child: Text(
                "Please select a quantity to confirm checkin",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            RaisedButton(
              onPressed: intent.checkInConfirmed,
              color: Theme.of(context).accentColor,
              child: Text(
                "Confirm \"${selectedBeer.name}\" checkin",
                style: TextStyle(
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
    final List<Widget> tiles = List();

    for(CheckInQuantity quantity in CheckInQuantity.values) {
      tiles.add(_buildQuantityTile(quantity, selectedQuantity == quantity));
    }

    return tiles;
  }

  Widget _buildQuantityTile(CheckInQuantity quantity, bool isSelected) {
    return Container(
      padding: EdgeInsets.only(left: 5.0, right: 5.0),
      child: GestureDetector(
        onTap: () { intent.quantitySelected(quantity); },
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Icon(IconData(0xe901, fontFamily: "beers")),
              Text(_getTextForQuantity(quantity)),
            ],
          ),
          decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: isSelected ? Colors.lightGreen[700] : Colors.grey[600]),
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
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
