import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

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
      padding: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0, bottom: 20.0),
      children: <Widget>[
        new Text(
          "THIS WEEK",
          style: new TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        new Padding(padding: EdgeInsets.only(top: 30.0)),
        new Text(
          "ALL TIME",
          style: new TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        new Padding(padding: EdgeInsets.only(top: 20.0)),
        new Offstage(
          offstage: profileData.favouriteBeer == null,
          child: new Column(
            children: <Widget>[
              new Text(
                "Favourite beer",
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              new BeerTile(beer: profileData.favouriteBeer?.beer),
              new Text("Drank ${profileData.favouriteBeer?.drankQuantity}L"),
            ],
          ),
        ),
        new Offstage(
          offstage: profileData.favouriteCategory == null,
          child: new Column(
            children: <Widget>[
              new Padding(padding: EdgeInsets.only(top: 20.0)),
              new Text(
                "Favourite category",
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              new Text(profileData.favouriteCategory?.name),
            ],
          ),
        ),
      ],
    );
    return new Text("Favourite beer: ${profileData.favouriteBeer?.beer?.name}, drank ${profileData.favouriteBeer?.drankQuantity}l. Favourite category: ${profileData.favouriteCategory?.name}");
  }
}