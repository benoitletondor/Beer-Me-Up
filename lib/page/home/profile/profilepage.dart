import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/model/beercheckinsdata.dart';
import 'package:beer_me_up/common/widget/loadingwidget.dart';
import 'package:beer_me_up/common/widget/erroroccurredwidget.dart';
import 'package:beer_me_up/service/userdataservice.dart';
import 'package:beer_me_up/common/mvi/viewstate.dart';
import 'package:beer_me_up/common/widget/beertile.dart';
import 'package:beer_me_up/localization/localization.dart';
import 'package:beer_me_up/common/widget/materialflatbutton.dart';
import 'package:beer_me_up/common/widget/ratingstars.dart';

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
      _intent.rateCheckIn,
      _intent.beerDetails,
      _intent.hideCheckInRating,
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
          (empty) => _buildEmptyWidget(empty.hasAlreadyCheckedIn),
          (loadNoAllTime) => _buildEmptyWidget(true),
          (loadNoWeek) => _buildLoadWidget(loadNoWeek.profileData),
          (load) => _buildLoadWidget(load.profileData),
          (error) => _buildErrorWidget(error: error.error),
        );
      },
    );
  }

  Widget _buildLoadingWidget() {
    return LoadingWidget();
  }

  Widget _buildEmptyWidget(bool hasAlreadyCheckedIn) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              Localization.of(context).homeWelcome,
              style: const TextStyle(
                fontFamily: "Google Sans",
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 40.0)),
          Image.asset("images/main_empty_state.png"),
          const Padding(padding: EdgeInsets.only(top: 40.0)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              hasAlreadyCheckedIn ? Localization.of(context).homeProfileWelcomeContinue : Localization.of(context).homeProfileWelcomeStart,
              style: TextStyle(
                fontFamily: "Google Sans",
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 20.0)),
          Image.asset("images/arrow_bottom.png"),
        ],
      ),
    );
  }

  Widget _buildErrorWidget({@required String error}) {
    return ErrorOccurredWidget(
      error: error,
      onRetry: intent.retry,
    );
  }

  Widget _buildLoadWidget(ProfileData profileData) {
    List<Widget> content = new List();

    if( profileData.checkInToRate != null ) {
      content.add(_buildRateCheckInWidget(profileData.checkInToRate));
    }

    content.add(const Padding(padding: EdgeInsets.only(top: 20.0)));

    if( profileData.hasWeek ) {
      content.addAll(_buildThisWeekSection(profileData));
    } else {
      content.addAll(_buildThisWeekEmptySection());
    }

    if( profileData.hasAllTime ) {
      content.addAll(_buildAllTimeSection(profileData));
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 45.0),
      children: content,
    );
  }

  List<Widget> _buildThisWeekSection(ProfileData profileData) {
    return <Widget> [
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
                  Text(
                    Localization.of(context).homeProfileThisWeek,
                    style: const TextStyle(
                      fontFamily: "Google Sans",
                      fontSize: 30.0,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 2.0)),
                  Offstage(
                    offstage: profileData.numberOfBeers > 1,
                    child: RichText(
                      text: TextSpan(
                        text: Localization.of(context).homeProfileOneBeerStart,
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
                          TextSpan(
                            text: Localization.of(context).homeProfileOneBeerEnd,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: profileData.numberOfBeers <= 1,
                    child: RichText(
                      text: TextSpan(
                        text: Localization.of(context).homeProfileMultipleBeersStart,
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
                          TextSpan(
                            text: Localization.of(context).homeProfileMultipleBeersEnd,
                          ),
                        ],
                      ),
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
        child: Text(
          Localization.of(context).homeProfileYourWeek,
          style: const TextStyle(
            fontFamily: "Google Sans",
            fontSize: 18.0,
          ),
        ),
      ),
      Column(
        children: _buildWeekBeers(profileData.weekBeers),
      ),
      const Padding(padding: EdgeInsets.only(top: 30.0)),
    ];
  }

  List<Widget> _buildAllTimeSection(ProfileData profileData) {
    return <Widget>[
      Container(
        child: Text(
          Localization.of(context).homeAllTime,
          style: const TextStyle(
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
              Localization.of(context).homeTotalPoints,
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
      Offstage(
        offstage: !profileData.hasTopBeers,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 20.0)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                Localization.of(context).homeFavoriteBeers,
                style: const TextStyle(
                  fontFamily: "Google Sans",
                  fontSize: 18.0,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 5.0)),
            _buildFavoriteBeers(profileData.beersRating),
          ],
        ),
      ),
      Offstage(
        offstage: profileData.mostDrankBeer == null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 20.0)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                Localization.of(context).homeMostDrankBeer,
                style: const TextStyle(
                  fontFamily: "Google Sans",
                  fontSize: 18.0,
                ),
              ),
            ),
            BeerTile(
              beer: profileData.mostDrankBeer?.beer,
              title: profileData.mostDrankBeer?.beer?.name,
              subtitle: "${profileData.mostDrankBeer?.numberOfCheckIns} ${Localization.of(context).times} - ${profileData.mostDrankBeer?.drankQuantity?.toStringAsPrecision(2)}L",
              onTap: () { intent.beerDetails(profileData.mostDrankBeer.beer); },
            )
          ],
        ),
      ),
      Offstage(
        offstage: profileData.mostDrankCategory == null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 20.0)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                Localization.of(context).homeMostDrankCategory,
                style: const TextStyle(
                  fontFamily: "Google Sans",
                  fontSize: 18.0,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10.0)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                profileData.mostDrankCategory?.name ?? "",
                style: const TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildThisWeekEmptySection() {
    return <Widget> [
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
                  Text(
                    Localization.of(context).homeProfileThisWeek,
                    style: const TextStyle(
                      fontFamily: "Google Sans",
                      fontSize: 30.0,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 2.0)),
                  Text(
                    Localization.of(context).homeEmptyWeek,
                    style: const TextStyle(
                      fontSize: 16.0,
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
                  const Text(
                    "0",
                    style: TextStyle(
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
      const Padding(padding: EdgeInsets.only(top: 30.0)),
    ];
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
      subtitle: "${beerCheckIn.numberOfCheckIns} ${Localization.of(context).times}, ${beerCheckIn.drankQuantity.toStringAsPrecision(2)}L",
      thirdTitle: "${Localization.of(context).homeLastTime} ${_beerCheckinDateFormatter.format(beerCheckIn.lastCheckinTime)}",
      onTap: () { intent.beerDetails(beerCheckIn.beer); },
    );
  }

  Widget _buildFavoriteBeers(Map<int, List<Beer>> beersRating) {
    if( beersRating.isEmpty ) {
      return Container();
    }

    final List<Widget> beers = List();
    int numberOfBeers = 0;
    for(int i = 5; i>0; i--) {
      final List<Beer> starBeers = beersRating[i];
      if( starBeers == null ) {
        continue;
      }

      if( numberOfBeers >= 10 ) {
        break;
      }

      starBeers.forEach((beer) {
        if( numberOfBeers >= 10 ) {
          return;
        }

        beers.add(BeerTile(
          beer: beer,
          title: beer.name,
          thirdWidget: RatingStars(
            rating: i,
            size: 14.0,
          ),
          onTap: () { intent.beerDetails(beer); },
        ));

        numberOfBeers++;
      });
    }

    return Column (
      children: beers,
    );
  }

  Widget _buildRateCheckInWidget(CheckInToRate checkInToRate) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    Localization.of(context).homeNewCheckInTitle,
                    style: const TextStyle(
                      fontFamily: "Google Sans",
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Material(
                  type: MaterialType.transparency,
                  child: IconButton(
                    iconSize: 22.0,
                    padding: const EdgeInsets.all(0.0),
                    icon: const Icon(Icons.close),
                    color: Colors.white,
                    onPressed: intent.hideCheckInRating,
                  ),
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10.0)),
          BeerTile(
            beer: checkInToRate.checkIn.beer,
            invertColors: true,
            title: checkInToRate.checkIn.beer.name,
            subtitle: checkInToRate.checkIn.beer.style?.name,
            thirdWidget: Column(
              children: <Widget>[
                Offstage(
                  offstage: checkInToRate.rating == null,
                  child: RatingStars(
                    rating: checkInToRate.rating ?? 0,
                    size: 18.0,
                    paddingBetweenStars: 0.0,
                    alignment: MainAxisAlignment.start,
                  ),
                ),
                Offstage(
                  offstage: checkInToRate.rating == null,
                  child: const Padding(padding: EdgeInsets.only(top: 10.0)),
                ),
                Row(
                  children: <Widget>[
                    Image.asset(
                      "images/coin.png",
                      width: 13.0,
                    ),
                    const Padding(padding: EdgeInsets.only(left: 5.0)),
                    Text(
                      checkInToRate.checkIn.points.toString(),
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              MaterialFlatButton(
                textColor: Colors.white,
                text: checkInToRate.rating == null ? Localization.of(context).homeNewCheckInRateCTA : Localization.of(context).homeNewCheckInEditRating,
                onPressed: () { intent.rateCheckIn(checkInToRate.checkIn); },
              )
            ],
          ),
        ],
      ),
    );
  }
}