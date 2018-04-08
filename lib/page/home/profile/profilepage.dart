import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/widget/loadingwidget.dart';
import 'package:beer_me_up/common/widget/erroroccurredwidget.dart';
import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/model/beercheckinsdata.dart';
import 'package:beer_me_up/service/userdataservice.dart';
import 'package:beer_me_up/common/mvi/viewstate.dart';

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
          (load) => _buildLoadWidget(load.favouriteBeer, load.favouriteBeerCategory),
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

  Widget _buildLoadWidget(BeerCheckInsData favouriteBeer, BeerCategory favouriteCategory) {
    return new Text("Favourite beer: ${favouriteBeer?.beer?.name}, drank ${favouriteBeer?.drankQuantity}l. Favourite category: ${favouriteCategory?.name}");
  }
}