import 'package:beer_me_up/model/beercheckinsdata.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

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

    final _intent = intent ?? ProfileIntent();
    final _model = model ?? ProfileViewModel(
      dataService ?? UserDataService.instance,
      _intent.retry,
    );

    return ProfilePage._(key: key, intent: _intent, model: _model);
  }

  @override
  _ProfilePageState createState() => _ProfilePageState(intent: intent, model: model);
}

class _ProfilePageState extends ViewState<ProfilePage, ProfileViewModel, ProfileIntent, ProfileState> {
  static final _beerCheckinDateFormatter = DateFormat.MMMEd().add_Hm();

  _ProfilePageState({
    @required ProfileIntent intent,
    @required ProfileViewModel model
  }): super(intent, model);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<ProfileState> snapshot) {
        if( !snapshot.hasData ) {
          return Container();
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
    return LoadingWidget();
  }

  Widget _buildErrorWidget({@required String error}) {
    return ErrorOccurredWidget(
      error: error,
      onRetry: intent.retry,
    );
  }

  Widget _buildLoadWidget(ProfileData profileData) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0, bottom: 45.0),
      children: <Widget>[
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Padding(padding: EdgeInsets.only(right: 16.0)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "This week",
                      style: TextStyle(
                        fontFamily: "Google Sans",
                        fontSize: 30.0,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 2.0)),
                    RichText(
                      text: TextSpan(
                        text: "You had ",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).textTheme.body1.color,
                        ),
                        children: <TextSpan> [
                          TextSpan(
                            text: "${profileData.numberOfBeers}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const TextSpan(
                            text: " different beers",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.only(right: 16.0)),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 22.0),
                margin: const EdgeInsets.only(top: 2.0),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      "images/coin.png",
                    ),
                    const Padding(padding: EdgeInsets.only(left: 8.0)),
                    Text(
                      "${profileData.weekPoints}",
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
              const Padding(padding: EdgeInsets.only(right: 16.0)),
            ],
          ),
        ),
        Padding(padding: const EdgeInsets.only(top: 30.0)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const Text(
            "Your week",
            style: TextStyle(
              fontFamily: "Google Sans",
              fontSize: 18.0,
            ),
          ),
        ),
        Column(
          children: _buildWeekBeers(profileData.weekBeers),
        ),
        const Padding(padding: EdgeInsets.only(top: 30.0)),
        Container(
          child: const Text(
            "All time",
            style: TextStyle(
              fontFamily: "Google Sans",
              fontSize: 30.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
        const Padding(padding: EdgeInsets.only(top: 2.0)),
        new Container(
          padding: const EdgeInsets.only(left: 16.0),
          child: new Row(
            children: <Widget>[
              Text(
                "Total of points: ",
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 5.0)),
              Image.asset(
                "images/coin.png",
                width: 13.0,
              ),
              const Padding(padding: EdgeInsets.only(left: 5.0)),
              Text(
                profileData.totalPoints.toString(),
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 20.0)),
        Offstage(
          offstage: profileData.favouriteBeer == null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Text(
                  "Your favourite beer",
                  style: TextStyle(
                    fontFamily: "Google Sans",
                    fontSize: 18.0,
                  ),
                ),
              ),
              BeerTile(
                beer: profileData.favouriteBeer?.beer,
                title: profileData.favouriteBeer?.beer?.name,
                subtitle: "${profileData.favouriteBeer?.numberOfCheckIns} times - ${profileData.favouriteBeer?.drankQuantity?.toStringAsPrecision(2)}L",
              )
            ],
          ),
        ),
        Offstage(
          offstage: profileData.favouriteCategory == null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Text(
                  "Your favourite category",
                  style: TextStyle(
                    fontFamily: "Google Sans",
                    fontSize: 18.0,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  profileData.favouriteCategory?.name ?? "",
                  style: const TextStyle(
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
    return BeerTile(
      beer: beerCheckIn.beer,
      title: beerCheckIn.beer.name,
      subtitle: "${beerCheckIn.numberOfCheckIns} times, ${beerCheckIn.drankQuantity.toStringAsFixed(2)}L",
      thirdTitle: "Last time: ${_beerCheckinDateFormatter.format(beerCheckIn.lastCheckinTime)}",
    );
  }
}