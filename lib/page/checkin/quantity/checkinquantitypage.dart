import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/model/checkin.dart';
import 'package:beer_me_up/common/mvi/viewstate.dart';
import 'package:beer_me_up/common/widget/beertile.dart';
import 'package:beer_me_up/common/widget/materialflatbutton.dart';
import 'package:beer_me_up/common/widget/materialraisedbutton.dart';

import 'model.dart';
import 'intent.dart';
import 'state.dart';

const String CHECK_IN_QUANTITY_PAGE_ROUTE = "/checkin/quantity";
const String SELECTED_CHECKIN_QUANTITY_KEY = "selectedQuantity";
const String SELECTED_CHECKIN_DATE_KEY = "selectedDate";

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
      _intent.changeDateTime,
    );

    return CheckInQuantityPage._(key: key, intent: _intent, model: _model);
  }

  @override
  State<CheckInQuantityPage> createState() => _CheckInQuantityPageState(intent: intent, model: model);
}

class _CheckInQuantityPageState extends ViewState<CheckInQuantityPage, CheckInQuantityViewModel, CheckInQuantityIntent, CheckInQuantityState> {
  final DateFormat formatter = DateFormat.MMMd().add_Hm();

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
          (base) => _buildBaseScreen(base.selectedBeer, base.date),
          (quantitySelected) => _buildQuantitySelectedScreen(quantitySelected.selectedBeer, quantitySelected.quantity, quantitySelected.date),
          (error) => _buildErrorScreen(error.selectedBeer, error.date),
        );
      },
    );
  }

  Widget _buildBaseScreen(Beer selectedBeer, DateTime date) => _buildScreen(selectedBeer, null, date, false);

  Widget _buildQuantitySelectedScreen(Beer selectedBeer, CheckInQuantity quantity, DateTime date) => _buildScreen(selectedBeer, quantity, date, false);

  Widget _buildErrorScreen(Beer selectedBeer, DateTime date) => _buildScreen(selectedBeer, null, date, true);

  Widget _buildScreen(Beer selectedBeer, CheckInQuantity selectedQuantity, DateTime date, bool error) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text(
          "Confirm check-in",
          style: TextStyle(
            fontFamily: "Google Sans",
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildBeerTile(selectedBeer),
            const Expanded(
              child: Padding(padding: EdgeInsets.zero),
            ),
            Row(
              children: <Widget>[
                Text(
                  formatter.format(date),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Google Sans",
                    fontSize: 18.0,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 16.0)),
                MaterialFlatButton(
                  text: "(Change date)",
                  textColor: Colors.white,
                  onPressed: intent.changeDateTime,
                )
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 16.0)),
            const Text(
              "Select quantity",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Google Sans",
                fontSize: 18.0,
              ),
            ),
            Offstage(
              offstage: !error,
              child: Column(
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(top: 20.0)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: Text(
                      "Please select a quantity to confirm checkin",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10.0)),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _buildQuantityTiles(selectedQuantity),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 30.0)),
            Center(
              child: MaterialRaisedButton.accent(
                context: context,
                text: "Check-in",
                onPressed: intent.checkInConfirmed,
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 16.0)),
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
    return InkWell(
      onTap: () { intent.quantitySelected(quantity); },
      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _getIconForQuantity(quantity),
            const SizedBox(height: 10.0),
            Container(
              constraints: const BoxConstraints(minWidth: 80.0),
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  Text(
                    _getDescriptorForQuantity(quantity),
                    style: TextStyle(
                      fontFamily: "Google Sans",
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                      fontSize: 15.0,
                    ),
                    maxLines: 1,
                  ),
                  Text(
                    _getQuantityDisplayText(quantity),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14.0,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
              decoration: BoxDecoration(
                border: Border.all(width: 3.0, color: isSelected ? Theme.of(context).accentColor : Colors.transparent),
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDescriptorForQuantity(CheckInQuantity quantity) {
    switch(quantity) {
      case CheckInQuantity.BOTTLE:
        return "Bottle";
      case CheckInQuantity.HALF_PINT:
        return "Half Pint";
      case CheckInQuantity.PINT:
        return "Pint";
    }

    return "Unknown";
  }

  String _getQuantityDisplayText(CheckInQuantity quantity) {
    return (quantity.value * 100.0).toStringAsFixed(0)+"cl";
  }

  Widget _getIconForQuantity(CheckInQuantity quantity) {
    switch(quantity) {
      case CheckInQuantity.BOTTLE:
        return Image.asset(
          "images/beer_bottle.png",
        );
      case CheckInQuantity.HALF_PINT:
        return Image.asset(
          "images/beer_half_pint.png",
        );
      case CheckInQuantity.PINT:
        return Image.asset(
          "images/beer_pint.png",
        );
    }

    return Container();
  }

  Widget _buildBeerTile(Beer selectedBeer) {
    final List<Widget> children = List();
    children.add(Text(
      selectedBeer.name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontFamily: "Google Sans",
        color: Colors.white,
        fontSize: 18.0,
      ),
    ));

    if( selectedBeer.style.shortName != null ) {
      children.add(Text(
        selectedBeer.style.shortName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.white,
        ),
      ));
    }

    if( selectedBeer.abv != null ) {
      children.add(const Padding(padding: EdgeInsets.only(top: 10.0)));
      children.add(Text(
        selectedBeer.abv.toStringAsPrecision(2) + "°",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.white,
        ),
      ));
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Row(
        children: <Widget>[
          _buildThumbnailImage(selectedBeer),
          const Padding(padding: EdgeInsets.only(right: 25.0)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnailImage(Beer beer) {
    Widget image;
    if (beer.label?.iconUrl == null) {
      image = const Icon(IconData(0xe900, fontFamily: "beers"), color: Colors.black,);
    } else {
      image = Image.network(
        beer.label.iconUrl,
      );
    }

    return Stack(
      children: <Widget>[
        Image.asset(
          "images/beer_icon_big_white_background.png",
          width: 100.0,
        ),
        Container(
          padding: const EdgeInsets.only(left: 24.0, top: 14.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 55.0, maxHeight: 60.0),
            child: Center(
              child: image,
            ),
          ),
        ),
      ],
    );
  }
}

Future<DateTime> showDateTimePicker(BuildContext context, DateTime initialDateTime) async {
  final DateTime date = await showDatePicker(
    context: context,
    initialDate: initialDateTime,
    firstDate: initialDateTime.subtract(const Duration(days: 365)),
    lastDate: initialDateTime,
  );

  final TimeOfDay time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDateTime),
  );

  final newDate = DateTime(
      date == null ? initialDateTime.year : date.year,
      date == null ? initialDateTime.month : date.month,
      date == null ? initialDateTime.day : date.day,
      time == null ? initialDateTime.hour : time.hour,
      time == null ? initialDateTime.minute : time.minute);

  return newDate.isBefore(initialDateTime) ? newDate : initialDateTime;
}
