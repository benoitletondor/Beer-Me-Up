import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../common/widget/loadingwidget.dart';
import '../../../common/widget/erroroccurredwidget.dart';
import '../../../model/beer.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage(this.userDoc, {Key key}) : super(key: key);

  final DocumentSnapshot userDoc;

  @override
  _HistoryPageState createState() => new _HistoryPageState(userDoc);
}

enum _HistoryStateStatus { LOADING, LOAD, ERROR }

class _HistoryPageState extends State<HistoryPage> {
  _HistoryPageState(this.userDoc);

  final DocumentSnapshot userDoc;

  String _error;
  List<Beer> _beers;
  _HistoryStateStatus _status = _HistoryStateStatus.LOADING;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    try {
      setState(() {
        _status = _HistoryStateStatus.LOADING;
      });

      final beersCollection = await userDoc.reference.getCollection("beers").getDocuments();
      if( beersCollection.documents.isEmpty ) {
        debugPrint("No beers registered for that user");
        _beers = new List(0);

        setState(() {
          _status = _HistoryStateStatus.LOAD;
        });

        return;
      }

      final beersArray = beersCollection.documents;
      debugPrint("Found ${beersArray.length} beers");

      _beers = new List();
      for(final beerDocument in beersArray) {
        _beers.add(new Beer(beerDocument.data["id"] as String));
      }

      setState(() {
        _status = _HistoryStateStatus.LOAD;
      });
    } catch (e) {
      _error = e;
      setState(() {
        _status = _HistoryStateStatus.ERROR;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch(_status) {
      case _HistoryStateStatus.LOADING:
        return new LoadingWidget();
      case _HistoryStateStatus.ERROR:
        return new ErrorOccurredWidget(_error, () {_loadData();});
      case _HistoryStateStatus.LOAD:
      // continue
        break;
    }

    return new Text("Beers: ${_beers.length}");
  }
}