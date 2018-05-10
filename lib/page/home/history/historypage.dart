import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:beer_me_up/common/widget/beertile.dart';
import 'package:beer_me_up/common/widget/loadingwidget.dart';
import 'package:beer_me_up/common/widget/erroroccurredwidget.dart';
import 'package:beer_me_up/model/checkin.dart';
import 'package:beer_me_up/service/userdataservice.dart';
import 'package:beer_me_up/common/mvi/viewstate.dart';
import 'package:beer_me_up/common/widget/materialraisedbutton.dart';

import 'model.dart';
import 'intent.dart';
import 'state.dart';

class HistoryPage extends StatefulWidget {
  final HistoryIntent intent;
  final HistoryViewModel model;

  HistoryPage._({
    Key key,
    @required this.intent,
    @required this.model,
  }) : super(key: key);

  factory HistoryPage({Key key,
    HistoryIntent intent,
    HistoryViewModel model,
    UserDataService dataService}) {

    final _intent = intent ?? HistoryIntent();
    final _model = model ?? HistoryViewModel(
      dataService ?? UserDataService.instance,
      _intent.retry,
      _intent.loadMore,
    );

    return HistoryPage._(key: key, intent: _intent, model: _model);
  }

  @override
  _HistoryPageState createState() => _HistoryPageState(intent: intent, model: model);
}

class _HistoryPageState extends ViewState<HistoryPage, HistoryViewModel, HistoryIntent, HistoryState> {
  static final _listSectionDateFormatter = DateFormat.yMMMMd();
  static final _listRowCheckInDateFormatter = DateFormat().add_Hm();

  _HistoryPageState({
    @required HistoryIntent intent,
    @required HistoryViewModel model
  }): super(intent, model);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<HistoryState> snapshot) {
        if( !snapshot.hasData ) {
          return Container();
        }

        return snapshot.data.join(
          (loading) => _buildLoadingWidget(),
          (load) => _buildLoadWidget(items: load.items),
          (error) => _buildErrorWidget(error: error.error),
        );
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 25.0),
      child: LoadingWidget(),
    );
  }

  Widget _buildErrorWidget({@required String error}) {
    return ErrorOccurredWidget(
      error: error,
      onRetryPressed: intent.retry
    );
  }

  Widget _buildLoadWidget({@required List<HistoryListItem> items}) {
    return ListView.builder(
      itemCount: items.length,
      padding: EdgeInsets.only(top: 20.0, bottom: 36.0),
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];

        if( item is HistoryListSection ) {
          return _buildListSectionWidget(item.date, index);
        } else if( item is HistoryListRow ) {
          return _buildListRow(item.checkIn);
        } else if( item is HistoryListLoadMore ) {
          return _buildListLoadMore(context);
        } else if( item is HistoryListLoading ) {
          return _buildListLoadingMore();
        }

        return Container();
      },
    );
  }

  Widget _buildListSectionWidget(DateTime date, int index) {
    return Container(
      padding: EdgeInsets.only(top: index == 0 ? 0.0 : 30.0, left: 16.0, right: 16.0),
      child: Text(
        _listSectionDateFormatter.format(date),
        style: const TextStyle(
          fontFamily: "Google Sans",
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget _buildListRow(CheckIn checkIn) {
    return BeerTile(
      beer: checkIn.beer,
      title: checkIn.beer.name,
      subtitle: "${_listRowCheckInDateFormatter.format(checkIn.date)} - ${(checkIn.quantity.value*100).toStringAsPrecision(2)}cl",
      thirdWidget: Row(
        children: <Widget>[
          Image.asset(
            "images/coin.png",
            width: 13.0,
          ),
          const Padding(padding: EdgeInsets.only(left: 5.0)),
          Text(
            checkIn.points.toString(),
            style: const TextStyle(
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListLoadMore(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 25.0),
      child: Center(
        child: MaterialRaisedButton.primary(
          context: context,
          text: "Load more",
          onPressed: intent.loadMore,
        ),
      ),
    );
  }

  Widget _buildListLoadingMore() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}