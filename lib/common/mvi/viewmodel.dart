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
    this._controller = StreamController();
    this._context = context;
    this._currentState = initialState();
    _controller.add(_currentState);
    return _controller.stream;
  }

  @override
  unbind() {
    _controller.close();
    _controller = null;
    _context = null;
  }

  getBuildContext() => _context;

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

  S getState() => _currentState;

  bool pushReplacementNamed(String name) {
    final context = _context;
    if( context == null ) {
      return false;
    }

    Navigator.of(context).pushReplacementNamed(name);
    return true;
  }

  bool pushReplacement<T extends Object, TO extends Object>(Route<T> newRoute) {
    final context = _context;
    if( context == null ) {
      return false;
    }

    Navigator.of(context).pushReplacement(newRoute);
    return true;
  }

  bool pushRoute<T extends Object, TO extends Object>(Route<T> newRoute) {
    final context = _context;
    if( context == null ) {
      return false;
    }

    Navigator.of(context).push(newRoute);
    return true;
  }
  
  bool pushNamedAndRemoveUntil(String name, RoutePredicate predicate) {
    final context = _context;
    if( context == null ) {
      return false;
    }

    Navigator.of(context).pushNamedAndRemoveUntil(name, predicate);
    return true;
  }

  Future<dynamic> pushNamed(String name) {
    final context = _context;
    if( context == null ) {
      return null;
    }

    return Navigator.of(context).pushNamed(name);
  }

  Future<dynamic> push(Route<dynamic> route) {
    final context = _context;
    if( context == null ) {
      return null;
    }

    return Navigator.of(context).push(route);
  }

  bool pop([dynamic result]) {
    final context = _context;
    if( context == null ) {
      return false;
    }

    Navigator.of(context).pop(result);
    return true;
  }

  bool popUntil(RoutePredicate predicate) {
    final context = _context;
    if( context == null ) {
      return false;
    }

    Navigator.of(context).popUntil(predicate);
    return true;
  }

  S initialState();
}