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
import 'package:beer_me_up/localization/localization.dart';

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

    final _intent = intent ?? HomeIntent();
    final _model = model ?? HomeViewModel(
      authService ?? AuthenticationService.instance,
      dataService ?? UserDataService.instance,
      _intent.showProfile,
      _intent.showHistory,
      _intent.retry,
      _intent.beerCheckIn,
      _intent.showSettingsPage,
    );

    return HomePage._(key: key, intent: _intent, model: _model);
  }

  @override
  _HomePageState createState() => _HomePageState(intent: intent, model: model);
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
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<HomeState> snapshot) {
        if( !snapshot.hasData ) {
          return Container();
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
    return Scaffold(
      appBar: _buildAppBar(true),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/beer_background.jpg"),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Offstage(
              offstage: index != _TAB_PROFILE_INDEX,
              child: TickerMode(
                enabled: index == _TAB_PROFILE_INDEX,
                child: ProfilePage(),
              ),
            ),
            Offstage(
              offstage: index != _TAB_HISTORY_INDEX,
              child: TickerMode(
                enabled: index == _TAB_HISTORY_INDEX,
                child: HistoryPage(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FittedBox(
        child: MaterialExtendedFAB(
          icon: Image.asset(
            "images/fab_icon.png",
            width: 20.0,
          ),
          text: Localization.of(context).homeCheckIn,
          color: Theme.of(context).accentColor,
          textColor: Colors.white,
          onPressed: intent.beerCheckIn,
        ),
      ),
      floatingActionButtonLocation: _CenterBottomNavBarFloatFabLocation(),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).primaryColor,
        ),
        child: BottomNavigationBar(
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
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              title: Text(
                Localization.of(context).profile,
                style: const TextStyle(
                  fontFamily: "Google Sans",
                ),
              ),
            ),
            const BottomNavigationBarItem( // Fake item
              icon: SizedBox(),
              title: SizedBox(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.history),
              title: Text(
                Localization.of(context).history,
                style: const TextStyle(
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
    return Scaffold(
      appBar: _buildAppBar(false),
      body: LoadingWidget(),
    );
  }

  Widget _buildErrorWidget({@required String error}) {
    return Scaffold(
      appBar: _buildAppBar(false),
      body: ErrorOccurredWidget(
        error: error,
        onRetry: intent.retry,
      ),
    );
  }

  AppBar _buildAppBar(bool authenticated) {
    final List<Widget> actions = List();
    if( authenticated ) {
      actions.add(PopupMenuButton<String>( // overflow menu
        icon: const Icon(Icons.more_vert),
        onSelected: (menu) {
          performSelectionHaptic(context);

          switch (menu) {
            case "settings" :
              intent.showSettingsPage();
              break;
          }
        },
        itemBuilder: (BuildContext context) {
          return [PopupMenuItem<String>(
            value: "settings",
            child: Text(
              Localization.of(context).settings,
              style: const TextStyle(
                fontFamily: "Google Sans",
              ),
            ),
          )];
        })
      );
    }

    return AppBar(
      title: Image.asset("images/toolbar_icon.png"),
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

    return Offset(fabX, fabY);
  }
}