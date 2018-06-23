import 'package:meta/meta.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import 'package:beer_me_up/service/userdataservice.dart';
import 'package:beer_me_up/common/mvi/viewstate.dart';
import 'package:beer_me_up/common/widget/loadingwidget.dart';
import 'package:beer_me_up/common/widget/erroroccurredwidget.dart';
import 'package:beer_me_up/common/hapticfeedback.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:beer_me_up/localization/localization.dart';
import 'package:beer_me_up/model/checkin.dart';
import 'package:beer_me_up/model/beer.dart';

import 'model.dart';
import 'intent.dart';
import 'state.dart';

const String BEER_DISPLAY_PAGE_ROUTE = "/beerDisplay";

class CheckInDisplayPage extends StatefulWidget {
  final CheckInDisplayIntent intent;
  final CheckInDisplayViewModel model;

  CheckInDisplayPage._({
    Key key,
    @required this.intent,
    @required this.model}) : super(key: key);

  factory CheckInDisplayPage({Key key,
    @required CheckIn checkIn,
    CheckInDisplayIntent intent,
    CheckInDisplayViewModel model,
    UserDataService dataService}) {

    final _intent = intent ?? CheckInDisplayIntent();
    final _model = model ?? CheckInDisplayViewModel(
      dataService ?? UserDataService.instance,
      checkIn,
      _intent.rate,
      _intent.retryLoadRating,
    );

    return CheckInDisplayPage._(key: key, intent: _intent, model: _model);
  }

  @override
  State<StatefulWidget> createState() => _CheckInDisplayPageState(intent: intent, model: model);
}

class _CheckInDisplayPageState extends ViewState<CheckInDisplayPage, CheckInDisplayViewModel, CheckInDisplayIntent, CheckInDisplayState> {
  final DateFormat formatter = DateFormat.MMMd().add_Hm();

  _CheckInDisplayPageState({
    @required CheckInDisplayIntent intent,
    @required CheckInDisplayViewModel model
  }) : super(intent, model);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<CheckInDisplayState> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return snapshot.data.join(
          (loading) => _buildLoadingScreen(loading.checkIn),
          (load) => _buildLoadScreen(load.checkIn, load.rating),
          (error) => _buildErrorScreen(error.checkIn, error.error),
        );
      },
    );
  }

  Widget _buildLoadScreen(CheckIn checkIn, int rating) {
    Widget ratingWidget;
    if( rating == null ) {
      ratingWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Localization.of(context).checkInDisplaySelectYourRating,
            style: const TextStyle(
              fontFamily: "Google Sans",
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10.0)),
          _buildRatingStars(0),
        ],
      );
    } else {
      ratingWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Localization.of(context).checkInDisplayYourRating,
            style: const TextStyle(
              fontFamily: "Google Sans",
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          Text(
            Localization.of(context).checkInDisplayChangeYourRatingHint,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.white,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10.0)),
          _buildRatingStars(rating),
        ],
      );
    }

    return _buildScreen(
      checkIn,
      ratingWidget,
    );
  }

  Widget _buildLoadingScreen(CheckIn checkIn) {
    return _buildScreen(
      checkIn,
      LoadingWidget(invertColors: true),
    );
  }

  _buildErrorScreen(CheckIn checkIn, String error) {
    return _buildScreen(
      checkIn,
      ErrorOccurredWidget(
        error: error,
        onRetry: intent.retryLoadRating,
        invertColors: true,
      ),
    );
  }

  Widget _buildScreen(CheckIn checkIn, Widget ratingWidget) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            Localization.of(context).checkInDisplayTitle,
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
              Text(
                formatter.format(checkIn.date),
                style: const TextStyle(
                  fontFamily: "Google Sans",
                  fontSize: 19.0,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              _buildBeerTile(checkIn.beer),
              const Padding(padding: EdgeInsets.only(top: 25.0)),
              _buildRatingWidget(ratingWidget),
              Offstage(
                offstage: checkIn.beer.description == null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(padding: EdgeInsets.only(top: 25.0)),
                    Text(
                      checkIn.beer.name,
                      style: const TextStyle(
                        fontFamily: "Google Sans",
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      )
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5.0)),
                    Text(
                      checkIn.beer.description ?? "",
                      style: const TextStyle(
                        fontSize: 15.0,
                        height: 1.2,
                      ),
                    )
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 30.0)),
            ],
          ),
        )
    );
  }

  Widget _buildBeerTile(Beer selectedBeer) {
    final List<Widget> children = List();
    children.add(Text(
      selectedBeer.name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontFamily: "Google Sans",
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      ),
    ));

    if( selectedBeer.style?.name != null ) {
      children.add(Text(
        selectedBeer.style.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 16.0,
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

  Widget _buildRatingWidget(Widget ratingWidget) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 122.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        color: Theme.of(context).primaryColor,
      ),
      child: ratingWidget,
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildStar(1, rating >= 1),
        _buildStar(2, rating >= 2),
        _buildStar(3, rating >= 3),
        _buildStar(4, rating >= 4),
        _buildStar(5, rating >= 5),
      ],
    );
  }

  Widget _buildStar(int index, bool selected) {
    return InkWell(
      onTap: () {
        performSelectionHaptic(context);
        intent.rate(index);
      },
      borderRadius: const BorderRadius.all(Radius.circular(50.0)),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          selected ? Icons.star : Icons.star_border,
          color: Colors.amberAccent[400],
        ),
      ),
    );
  }
}