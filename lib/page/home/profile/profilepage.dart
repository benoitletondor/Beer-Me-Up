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
      onRetryPressed: intent.retry,
    );
  }

  Widget _buildLoadWidget(ProfileData profileData) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0, bottom: 36.0),
      children: <Widget>[
        Container(
          child: const Text(
            "This week",
            style: TextStyle(
              fontFamily: "Google Sans",
              fontSize: 24.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
        Padding(padding: const EdgeInsets.only(top: 16.0)),
        Container(
          child: Row(
            children: <Widget>[
              const Text(
                "You drank: ",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Text(
                "${profileData.weekDrankQuantity.toStringAsPrecision(2)}L",
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
        const Padding(padding: EdgeInsets.only(top: 20.0)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const Text(
            "Top 5",
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
              fontSize: 24.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                subtitle: "Drank ${profileData.favouriteBeer?.numberOfCheckIns} times - ${profileData.favouriteBeer?.drankQuantity?.toStringAsPrecision(2)}L",
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
      subtitle: "Drank ${beerCheckIn.numberOfCheckIns} times, ${beerCheckIn.drankQuantity.toStringAsFixed(2)}L.",
      thirdTitle: "Last time: ${_beerCheckinDateFormatter.format(beerCheckIn.lastCheckinTime)}",
    );
  }
}