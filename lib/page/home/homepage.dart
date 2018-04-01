import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:beer_me_up/common/mvi/viewstate.dart';
import 'package:beer_me_up/common/widget/loadingwidget.dart';
import 'package:beer_me_up/common/widget/erroroccurredwidget.dart';
import 'package:beer_me_up/page/home/profile/profilepage.dart';
import 'package:beer_me_up/page/home/history/historypage.dart';
import 'package:beer_me_up/service/authenticationservice.dart';
import 'package:beer_me_up/service/userdataservice.dart';

import 'state.dart';
import 'model.dart';
import 'intent.dart';

class HomePage extends StatefulWidget {
  final HomeIntent intent;
  final HomeViewModel model;

  HomePage._({
    Key key,
    @required this.intent,
    @required this.model,
  }) : super(key: key);

  factory HomePage({Key key,
    HomeIntent intent,
    HomeViewModel model,
    AuthenticationService authService,
    UserDataService dataService}) {

    final _intent = intent ?? new HomeIntent();
    final _model = model ?? new HomeViewModel(
      authService ?? AuthenticationService.instance,
      dataService ?? UserDataService.instance,
      _intent.showProfile,
      _intent.showHistory,
      _intent.retry,
      _intent.beerCheckIn,
    );

    return new HomePage._(key: key, intent: _intent, model: _model);
  }

  @override
  _HomePageState createState() => new _HomePageState(intent: intent, model: model);
}

class _HomePageState extends ViewState<HomePage, HomeViewModel, HomeIntent, HomeState> {

  static const _TAB_PROFILE_INDEX = 0;
  static const _TAB_HISTORY_INDEX = 1;

  _HomePageState({
    @required HomeIntent intent,
    @required HomeViewModel model
  }): super(intent, model);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<HomeState> snapshot) {
        if( !snapshot.hasData ) {
          return new Container();
        }

        return snapshot.data.join(
          (authenticating) => _buildLoadingWidget(),
          (loading) => _buildLoadingWidget(),
          (tabProfile) => _buildContentWidget(_TAB_PROFILE_INDEX),
          (tabHistory) => _buildContentWidget(_TAB_HISTORY_INDEX),
          (error) =>  _buildErrorWidget(error: error.error),
        );
      },
    );
  }

  Widget _buildContentWidget(int index) {
    return new Scaffold(
      appBar: _buildAppBar(),
      body: new Center(
        child: new Stack(
          children: <Widget>[
            new Offstage(
              offstage: index != _TAB_PROFILE_INDEX,
              child: new TickerMode(
                enabled: index == _TAB_PROFILE_INDEX,
                child: new ProfilePage(),
              ),
            ),
            new Offstage(
              offstage: index != _TAB_HISTORY_INDEX,
              child: new TickerMode(
                enabled: index == _TAB_HISTORY_INDEX,
                child: new HistoryPage(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: intent.beerCheckIn,
        tooltip: 'Check-in',
        child: new Icon(const IconData(0xe901, fontFamily: "beers")),
      ),
      floatingActionButtonLocation: new _CenterBottomNavBarFloatFabLocation(),
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: index,
        onTap: (int index) {
          if( index == _TAB_PROFILE_INDEX ) {
            return intent.showProfile();
          } else {
            return intent.showHistory();
          }
        },
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text("Profile"),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.history),
            title: new Text("History"),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return new Scaffold(
      appBar: _buildAppBar(),
      body: new LoadingWidget(),
    );
  }

  Widget _buildErrorWidget({@required String error}) {
    return new Scaffold(
      appBar: _buildAppBar(),
      body: new ErrorOccurredWidget(
        error,
        () => intent.retry(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return new AppBar(
      title: new Text('Beer Me Up'),
    );
  }
}

class _CenterBottomNavBarFloatFabLocation extends FloatingActionButtonLocation {
  const _CenterBottomNavBarFloatFabLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Compute the x-axis offset.
    final double fabX = (scaffoldGeometry.scaffoldSize.width - scaffoldGeometry.floatingActionButtonSize.width) / 2.0;

    // Compute the y-axis offset.
    final double contentBottom = scaffoldGeometry.contentBottom;
    final double bottomSheetHeight = scaffoldGeometry.bottomSheetSize.height;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double snackBarHeight = scaffoldGeometry.snackBarSize.height;
    double fabY = contentBottom - fabHeight - kFloatingActionButtonMargin;
    if (snackBarHeight > 0.0)
      fabY = math.min(fabY, contentBottom - snackBarHeight - fabHeight - kFloatingActionButtonMargin);
    if (bottomSheetHeight > 0.0)
      fabY = math.min(fabY, contentBottom - bottomSheetHeight - fabHeight / 2.0);

    fabY += (scaffoldGeometry.floatingActionButtonSize.height / 1.3);

    return new Offset(fabX, fabY);
  }
}