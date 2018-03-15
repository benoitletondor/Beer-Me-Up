import 'dart:async';
import 'package:flutter/material.dart';

abstract class ViewModel<S> {
  Stream<S> bind(BuildContext context);
  unbind();
}

abstract class BaseViewModel<S> extends ViewModel<S> {

  StreamController<S> _controller;
  BuildContext _context;
  S _currentState;

  @override
  Stream<S> bind(BuildContext context) {
    this._controller = new StreamController();
    this._context = context;
    _controller.add(initialState());
    return _controller.stream;
  }

  @override
  unbind() {
    _controller.close();
    _controller = null;
    _context = null;
  }

  bool setState(S newState) {
    final controller = _controller;
    if( controller == null ) {
      return false;
    }

    if( newState == _currentState ) {
      return true;
    }

    controller.add(newState);

    _currentState = newState;
    return true;
  }

  bool pushReplacementNamed(String name) {
    final context = _context;
    if( context == null ) {
      return false;
    }

    Navigator.of(context).pushReplacementNamed(name);
    return true;
  }

  S initialState();
}