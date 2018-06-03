import 'dart:async';
import 'package:flutter/material.dart';

import 'viewmodel.dart';

abstract class ViewState<T extends StatefulWidget, M extends ViewModel, I, S> extends State<T> {

  ViewState(this.intent, this._model);

  final I intent;
  final M _model;

  Stream<S> stream;

  @override
  void initState() {
    super.initState();
    stream = _model.bind(context);
  }

  @override
  void dispose() {
    _model.unbind();
    stream = null;

    super.dispose();
  }

}