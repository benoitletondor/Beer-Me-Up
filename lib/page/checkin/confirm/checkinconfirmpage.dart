import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/model/checkin.dart';
import 'package:beer_me_up/common/mvi/viewstate.dart';
import 'package:beer_me_up/common/widget/materialflatbutton.dart';
import 'package:beer_me_up/common/widget/materialraisedbutton.dart';
import 'package:beer_me_up/service/userdataservice.dart';
import 'package:beer_me_up/common/widget/loadingwidget.dart';
import 'package:beer_me_up/common/widget/erroroccurredwidget.dart';
import 'package:beer_me_up/service/config.dart';
import 'package:beer_me_up/main.dart';
import 'package:beer_me_up/localization/localization.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'model.dart';
import 'intent.dart';
import 'state.dart';

const String CHECK_IN_CONFIRM_PAGE_ROUTE = "/checkin/confirm";
const String SELECTED_CHECKIN_QUANTITY_KEY = "selectedQuantity";
const String SELECTED_CHECKIN_DATE_KEY = "selectedDate";
const String CHECKIN_POINTS_KEY = "checkinPoints";

class CheckInConfirmPage extends StatefulWidget {
  final CheckInConfirmIntent intent;
  final CheckInConfirmViewModel model;

  CheckInConfirmPage._({
    Key key,
    @required this.intent,
    @required this.model,
  }) : super(key: key);

  factory CheckInConfirmPage({
    Key key,
    @required Beer selectedBeer,
    CheckInConfirmIntent intent,
    CheckInConfirmViewModel model,
    UserDataService dataService,
    Config config,
    }) {

    final _intent = intent ?? CheckInConfirmIntent();
    final _model = model ?? CheckInConfirmViewModel(
      selectedBeer,
      dataService ?? UserDataService.instance,
      config ?? BeerMeUpApp.config,
      _intent.quantitySelected,
      _intent.checkInConfirmed,
      _intent.changeDateTime,
      _intent.retry,
    );

    return CheckInConfirmPage._(key: key, intent: _intent, model: _model);
  }

  @override
  State<CheckInConfirmPage> createState() => _CheckInConfirmPageState(intent: intent, model: model);
}

class _CheckInConfirmPageState extends ViewState<CheckInConfirmPage, CheckInConfirmViewModel, CheckInConfirmIntent, CheckInConfirmState> {
  final DateFormat formatter = DateFormat.MMMd().add_Hm();

  _CheckInConfirmPageState({
    @required CheckInConfirmIntent intent,
    @required CheckInConfirmViewModel model
  }) : super(intent, model);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<CheckInConfirmState> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return snapshot.data.join(
          (loading) => _buildScreen(loading.selectedBeer, loading.quantity, loading.date, null, false, null),
          (load) => _buildScreen(load.selectedBeer, load.quantity, load.date, load.points, false, null),
          (quantityNotSelected) => _buildScreen(quantityNotSelected.selectedBeer, null, quantityNotSelected.date, quantityNotSelected.points, true, null),
          (errorFetchingPoints) => _buildScreen(errorFetchingPoints.selectedBeer, errorFetchingPoints.quantity, errorFetchingPoints.date, null, false, errorFetchingPoints.error),
        );
      },
    );
  }

  Widget _buildScreen(Beer selectedBeer, CheckInQuantity selectedQuantity, DateTime date, CheckinPoints points, bool quantityNotSelectedError, String loadingError) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          Localization.of(context).checkInConfirmTitle,
          style: const TextStyle(
            fontFamily: "Google Sans",
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const ScrollPhysics(),
          padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
          children: <Widget>[
            _buildBeerTile(selectedBeer),
            const Padding(padding: EdgeInsets.only(top: 16.0)),
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
                MaterialFlatButton(
                  text: "(${Localization.of(context).checkInChangeDateCTA})",
                  textColor: Colors.white,
                  onPressed: intent.changeDateTime,
                )
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 16.0)),
            _buildPointsWidget(points, loadingError),
            const Padding(padding: EdgeInsets.only(top: 16.0)),
            Text(
              Localization.of(context).checkInSelectQuantity,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: "Google Sans",
                fontSize: 18.0,
              ),
            ),
            Offstage(
              offstage: !quantityNotSelectedError,
              child: Column(
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(top: 20.0)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: Text(
                      Localization.of(context).checkInNoQuantitySelected,
                      style: const TextStyle(
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
            const Padding(padding: EdgeInsets.only(top: 5.0)),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _buildQuantityTiles(selectedQuantity),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20.0)),
            Center(
              child: MaterialRaisedButton.accent(
                context: context,
                text: Localization.of(context).checkInConfirmCTA,
                onPressed: intent.checkInConfirmed,
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 30.0)),
          ],
        ),
      )
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
        padding: const EdgeInsets.all(5.0),
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
                    quantity.quantityToString(context),
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

  String _getQuantityDisplayText(CheckInQuantity quantity) {
    return (quantity.value * 100.0).toStringAsFixed(0)+"cl";
  }

  Widget _getIconForQuantity(CheckInQuantity quantity) {
    switch(quantity) {
      case CheckInQuantity.BOTTLE:
        return Image.asset(
          "images/beer_bottle.png",
          height: 74.0,
        );
      case CheckInQuantity.HALF_PINT:
        return Image.asset(
          "images/beer_half_pint.png",
          height: 47.0,
        );
      case CheckInQuantity.PINT:
        return Image.asset(
          "images/beer_pint.png",
          height: 47.0,
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

    if( selectedBeer.style?.name != null ) {
      children.add(Text(
        selectedBeer.style.name,
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
      image = Container(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Image.asset("images/default_beer.png"),
      );
    } else {
      image = CachedNetworkImage(
        imageUrl: beer.label.iconUrl,
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

  Widget _buildPointsWidget(CheckinPoints points, String loadingError) {
    Widget child;
    if( points == null ) {
      if( loadingError != null  ) {
        child = ErrorOccurredWidget(
          error: loadingError,
          onRetry: intent.retry,
        );
      } else {
        child = LoadingWidget();
      }
    } else {
      final details = points.details.map((detail) {
        return Container(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: RichText(
            text: TextSpan(
              text: "• ${_pointDetailTypeDescription(detail.type)}: ",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 15.0,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: detail.points.toString(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(growable: false);

      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: details,
          ),
          const Padding(padding: EdgeInsets.only(top: 10.0)),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  "images/coin.png",
                  width: 18.0,
                ),
                const Padding(padding: EdgeInsets.only(left: 5.0)),
                Text(
                  points.total.toString(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 50.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.white,
      ),
      child: child,
    );
  }

  String _pointDetailTypeDescription(PointType type) {
    switch(type) {
      case PointType.DEFAULT:
        return Localization.of(context).checkInConfirmDefaultPoints;
      case PointType.FIRST_BEER_CHECKIN:
        return Localization.of(context).checkInConfirmFirstTimeBeer;
      case PointType.FIRST_WEEK_BEER_CHECKIN:
        return Localization.of(context).checkInConfirmFirstTimeWeekBeer;
      case PointType.FIRST_WEEK_CATEGORY_CHECKIN:
        return Localization.of(context).checkInConfirmFirstTimeWeekCategory;
      case PointType.FIRST_WEEK_CHECKIN:
        return Localization.of(context).checkInConfirmFirstWeekBeer;
    }

    return "";
  }

}

Future<DateTime> showDateTimePicker(BuildContext context, DateTime initialDateTime) async {
  final DateTime date = await showDatePicker(
    context: context,
    initialDate: initialDateTime,
    firstDate: initialDateTime.subtract(const Duration(days: 365)),
    lastDate: DateTime.now(),
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

  return newDate.isBefore(initialDateTime) ? newDate : newDate.isBefore(DateTime.now()) ? newDate : initialDateTime;
}
