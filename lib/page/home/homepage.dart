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
import 'package:beer_me_up/common/hapticfeedback.dart';
import 'package:beer_me_up/common/widget/materialextendedfab.dart';

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
      _intent.showAccountPage,
    );

    return new HomePage._(key: key, intent: _intent, model: _model);
  }

  @override
  _HomePageState createState() => new _HomePageState(intent: intent, model: model);
}

class _HomePageState extends ViewState<HomePage, HomeViewModel, HomeIntent, HomeState> {

  static const _TAB_PROFILE_INDEX = 0;
  static const _TAB_FAKE_INDEX = 1;
  static const _TAB_HISTORY_INDEX = 2;

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
      appBar: _buildAppBar(true),
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
      floatingActionButton: new FittedBox(
        child: new MaterialExtendedFAB(
          icon: new Image.asset(
            "images/fab_icon.png",
            width: 20.0,
          ),
          text: "Check-in",
          color: Theme.of(context).accentColor,
          textColor: Colors.white,
          onPressed: intent.beerCheckIn,
        ),
      ),
      floatingActionButtonLocation: new _CenterBottomNavBarFloatFabLocation(),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).primaryColor,
        ),
        child: new BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          fixedColor: Colors.white,
          onTap: (int index) {
            performSelectionHaptic(context);

            if( index == _TAB_PROFILE_INDEX ) {
              intent.showProfile();
            } else if( index == _TAB_FAKE_INDEX ) {
              intent.beerCheckIn();
            } else {
              intent.showHistory();
            }
          },
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
              icon: new Icon(Icons.person),
              title: new Text(
                "Profile",
                style: new TextStyle(
                  fontFamily: "Google Sans",
                ),
              ),
            ),
            new BottomNavigationBarItem( // Fake item
              icon: new Container(),
              title: new Container(),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.history),
              title: new Text(
                "History",
                style: new TextStyle(
                  fontFamily: "Google Sans",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return new Scaffold(
      appBar: _buildAppBar(false),
      body: new LoadingWidget(),
    );
  }

  Widget _buildErrorWidget({@required String error}) {
    return new Scaffold(
      appBar: _buildAppBar(false),
      body: new ErrorOccurredWidget(
        error,
        () => intent.retry(),
      ),
    );
  }

  AppBar _buildAppBar(bool authenticated) {
    final List<Widget> actions = new List();
    if( authenticated ) {
      actions.add(new PopupMenuButton<String>( // overflow menu
        icon: new Icon(Icons.more_vert),
        onSelected: (menu) {
          performSelectionHaptic(context);

          switch (menu) {
            case "account" :
              intent.showAccountPage();
              break;
          }
        },
        itemBuilder: (BuildContext context) {
          return [new PopupMenuItem<String>(
            value: "account",
            child: new Text(
              "Account",
              style: new TextStyle(
                fontFamily: "Google Sans",
              ),
            ),
          )];
        })
      );
    }

    return new AppBar(
      title: new Image.asset("images/toolbar_icon.png"),
      centerTitle: true,
      actions: actions,
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