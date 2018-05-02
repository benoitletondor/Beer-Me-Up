import 'package:beer_me_up/model/beercheckinsdata.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:beer_me_up/common/widget/loadingwidget.dart';
import 'package:beer_me_up/common/widget/erroroccurredwidget.dart';
import 'package:beer_me_up/service/userdataservice.dart';
import 'package:beer_me_up/common/mvi/viewstate.dart';
import 'package:beer_me_up/common/widget/beertile.dart';

import 'model.dart';
import 'intent.dart';
import 'state.dart';

class ProfilePage extends StatefulWidget {
  final ProfileIntent intent;
  final ProfileViewModel model;

  ProfilePage._({
    Key key,
    @required this.intent,
    @required this.model,
  }) : super(key: key);

  factory ProfilePage({Key key,
    ProfileIntent intent,
    ProfileViewModel model,
    UserDataService dataService}) {

    final _intent = intent ?? new ProfileIntent();
    final _model = model ?? new ProfileViewModel(
      dataService ?? UserDataService.instance,
      _intent.retry,
    );

    return new ProfilePage._(key: key, intent: _intent, model: _model);
  }

  @override
  _ProfilePageState createState() => new _ProfilePageState(intent: intent, model: model);
}

class _ProfilePageState extends ViewState<ProfilePage, ProfileViewModel, ProfileIntent, ProfileState> {
  static final _beerCheckinDateFormatter = new DateFormat.MMMEd().add_Hm();

  _ProfilePageState({
    @required ProfileIntent intent,
    @required ProfileViewModel model
  }): super(intent, model);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<ProfileState> snapshot) {
        if( !snapshot.hasData ) {
          return new Container();
        }

        return snapshot.data.join(
          (loading) => _buildLoadingWidget(),
          (load) => _buildLoadWidget(load.profileData),
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

  Widget _buildLoadWidget(ProfileData profileData) {
    return new ListView(
      padding: const EdgeInsets.only(top: 20.0, bottom: 36.0),
      children: <Widget>[
        new Container(
          child: new Text(
            "This week",
            style: new TextStyle(
              fontFamily: "Google Sans",
              color: Colors.blueGrey[900],
              fontSize: 24.0,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        new Padding(padding: EdgeInsets.only(top: 16.0)),
        new Container(
          child: new Row(
            children: <Widget>[
              new Text(
                "You drank: ",
                style: new TextStyle(
                  fontSize: 16.0,
                  color: Colors.blueGrey[900],
                ),
              ),
              new Text(
                "${profileData.weekDrankQuantity.toStringAsPrecision(2)}L",
                style: new TextStyle(
                  fontSize: 16.0,
                  color: Colors.blueGrey[900],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        new Padding(padding: EdgeInsets.only(top: 20.0)),
        new Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: new Text(
            "Top 5",
            style: new TextStyle(
              fontFamily: "Google Sans",
              fontSize: 18.0,
              color: Colors.blueGrey[900],
            ),
          ),
        ),
        new Column(
          children: _buildWeekBeers(profileData.weekBeers),
        ),
        new Padding(padding: EdgeInsets.only(top: 30.0)),
        new Container(
          child: new Text(
            "All time",
            style: new TextStyle(
              fontFamily: "Google Sans",
              color: Colors.blueGrey[900],
              fontSize: 24.0,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        new Padding(padding: EdgeInsets.only(top: 20.0)),
        new Offstage(
          offstage: profileData.favouriteBeer == null,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: new Text(
                  "Your favourite beer",
                  style: new TextStyle(
                    fontFamily: "Google Sans",
                    fontSize: 18.0,
                    color: Colors.blueGrey[900],
                  ),
                ),
              ),
              new BeerTile(
                beer: profileData.favouriteBeer?.beer,
                title: profileData.favouriteBeer?.beer?.name,
                subtitle: "Drank ${profileData.favouriteBeer?.numberOfCheckIns} times - ${profileData.favouriteBeer?.drankQuantity?.toStringAsPrecision(2)}L",
              )
            ],
          ),
        ),
        new Offstage(
          offstage: profileData.favouriteCategory == null,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Padding(padding: EdgeInsets.only(top: 20.0)),
              new Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: new Text(
                  "Your favourite category",
                  style: new TextStyle(
                    fontFamily: "Google Sans",
                    fontSize: 18.0,
                    color: Colors.blueGrey[900],
                  ),
                ),
              ),
              new Padding(padding: EdgeInsets.only(top: 10.0)),
              new Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: new Text(
                  profileData.favouriteCategory?.name ?? "",
                  style: new TextStyle(
                    color: Colors.blueGrey[900],
                    fontSize: 15.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildWeekBeers(List<BeerCheckInsData> weekBeers) {
    return weekBeers
      .map((checkInData) => _buildWeekBeer(checkInData))
      .toList(growable: false);
  }

  Widget _buildWeekBeer(BeerCheckInsData beerCheckIn) {
    return new BeerTile(
      beer: beerCheckIn.beer,
      title: beerCheckIn.beer.name,
      subtitle: "Drank ${beerCheckIn.numberOfCheckIns} times, ${beerCheckIn.drankQuantity.toStringAsFixed(2)}L.",
      thirdTitle: "Last time: ${_beerCheckinDateFormatter.format(beerCheckIn.lastCheckinTime)}",
    );
  }
}