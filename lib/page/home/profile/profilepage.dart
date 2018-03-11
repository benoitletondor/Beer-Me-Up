import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../common/widget/loadingwidget.dart';
import '../../../common/widget/erroroccurredwidget.dart';
import '../../../model/beer.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage(this.userDoc, {Key key}) : super(key: key);

  final DocumentSnapshot userDoc;

  @override
  _ProfilePageState createState() => new _ProfilePageState(userDoc);
}

enum _ProfileStateStatus { LOADING, LOAD, ERROR }

class _ProfilePageState extends State<ProfilePage> {
  _ProfilePageState(this.userDoc);

  final DocumentSnapshot userDoc;

  String _error;
  List<Beer> _beers;
  _ProfileStateStatus _status = _ProfileStateStatus.LOADING;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    try {
      setState(() {
        _status = _ProfileStateStatus.LOADING;
      });

      final beersCollection = await userDoc.reference.getCollection("beers").getDocuments();
      if( beersCollection.documents.isEmpty ) {
        debugPrint("No beers registered for that user");
        _beers = new List(0);

        setState(() {
          _status = _ProfileStateStatus.LOAD;
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
        _status = _ProfileStateStatus.LOAD;
      });
    } catch (e) {
      _error = e;
      setState(() {
        _status = _ProfileStateStatus.ERROR;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch(_status) {
      case _ProfileStateStatus.LOADING:
        return new LoadingWidget();
      case _ProfileStateStatus.ERROR:
        return new ErrorOccurredWidget(_error, () {_loadData();});
      case _ProfileStateStatus.LOAD:
        // continue
        break;
    }

    return new Text("Beers: $_beers");
  }
}