import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'package:beer_me_up/service/userdataservice.dart';
import 'package:beer_me_up/common/mvi/viewstate.dart';
import 'package:beer_me_up/common/widget/loadingwidget.dart';
import 'package:beer_me_up/common/widget/erroroccurredwidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:beer_me_up/localization/localization.dart';
import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/common/widget/ratingstars.dart';

import 'model.dart';
import 'intent.dart';
import 'state.dart';

const String RATING_PAGE_ROUTE = "/rating";

class RatingPage extends StatefulWidget {
  final RatingIntent intent;
  final RatingViewModel model;

  RatingPage._({
    Key key,
    @required this.intent,
    @required this.model}) : super(key: key);

  factory RatingPage({Key key,
    @required Beer beer,
    RatingIntent intent,
    RatingViewModel model,
    UserDataService dataService}) {

    final _intent = intent ?? RatingIntent();
    final _model = model ?? RatingViewModel(
      dataService ?? UserDataService.instance,
      beer,
      _intent.rate,
      _intent.retryLoadRating,
    );

    return RatingPage._(key: key, intent: _intent, model: _model);
  }

  @override
  State<StatefulWidget> createState() => _RatingPageState(intent: intent, model: model);
}

class _RatingPageState extends ViewState<RatingPage, RatingViewModel, RatingIntent, RatingState> {

  _RatingPageState({
    @required RatingIntent intent,
    @required RatingViewModel model
  }) : super(intent, model);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<RatingState> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return snapshot.data.join(
          (loading) => _buildLoadingScreen(loading.beer),
          (load) => _buildLoadScreen(load.beer, load.rating),
          (error) => _buildErrorScreen(error.beer, error.error),
        );
      },
    );
  }

  Widget _buildLoadScreen(Beer beer, int rating) {
    Widget ratingWidget;
    if( rating == null ) {
      ratingWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Localization.of(context).ratingSelectYourRating,
            style: const TextStyle(
              fontFamily: "Google Sans",
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10.0)),
          RatingStars(
            rating: 0,
            size: 24.0,
            onTap: intent.rate,
            paddingBetweenStars: 8.0,
            alignment: MainAxisAlignment.center,
          ),
        ],
      );
    } else {
      ratingWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Localization.of(context).ratingYourRating,
            style: const TextStyle(
              fontFamily: "Google Sans",
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          Text(
            Localization.of(context).ratingChangeYourRatingHint,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.white,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10.0)),
          RatingStars(
            rating: rating,
            size: 24.0,
            onTap: intent.rate,
            paddingBetweenStars: 8.0,
            alignment: MainAxisAlignment.center,
          ),
        ],
      );
    }

    return _buildScreen(
      beer,
      ratingWidget,
    );
  }

  Widget _buildLoadingScreen(Beer beer) {
    return _buildScreen(
      beer,
      LoadingWidget(invertColors: true),
    );
  }

  _buildErrorScreen(Beer beer, String error) {
    return _buildScreen(
      beer,
      ErrorOccurredWidget(
        error: error,
        onRetry: intent.retryLoadRating,
        invertColors: true,
      ),
    );
  }

  Widget _buildScreen(Beer beer, Widget ratingWidget) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            beer.name,
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
              _buildBeerTile(beer),
              const Padding(padding: EdgeInsets.only(top: 25.0)),
              _buildRatingWidget(ratingWidget),
              Offstage(
                offstage: beer.description == null || beer.description.isEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(padding: EdgeInsets.only(top: 25.0)),
                    Text(
                      beer.name,
                      style: const TextStyle(
                        fontFamily: "Google Sans",
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      )
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5.0)),
                    Text(
                      beer.description ?? "",
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
}