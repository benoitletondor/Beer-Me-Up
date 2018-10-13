import 'dart:async';
import 'package:flutter/material.dart';

abstract class ViewModel<S> {
  Stream<S> bind(BuildContext context);
  unbind();
}

abstract class BaseViewModel<S> extends ViewModel<S> {

  StreamController<S> _controller;
  S _currentState;
  BuildContext _context;
  NavigatorState _navigator;

  @override
  Stream<S> bind(BuildContext context) {
    this._controller = StreamController();
    this._context = context;
    this._navigator = context != null ? Navigator.of(context) : null;
    this._currentState = initialState();
    _controller.add(_currentState);
    return _controller.stream;
  }

  @override
  unbind() {
    _controller.close();
    _controller = null;
    _navigator = null;
    _context = null;
  }

  getBuildContext() => _context;

  @visibleForTesting
  void setNavigator(NavigatorState navigator) {
    _navigator = navigator;
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

  S getState() => _currentState;

  bool pushReplacementNamed(String name) {
    final navigator = _navigator;
    if( navigator == null ) {
      return false;
    }

    navigator.pushReplacementNamed(name);
    return true;
  }

  bool pushReplacement<T extends Object, TO extends Object>(Route<T> newRoute) {
    final navigator = _navigator;
    if( navigator == null ) {
      return false;
    }

    navigator.pushReplacement(newRoute);
    return true;
  }

  bool pushRoute<T extends Object, TO extends Object>(Route<T> newRoute) {
    final navigator = _navigator;
    if( navigator == null ) {
      return false;
    }

    navigator.push(newRoute);
    return true;
  }
  
  bool pushNamedAndRemoveUntil(String name, RoutePredicate predicate) {
    final navigator = _navigator;
    if( navigator == null ) {
      return false;
    }

    navigator.pushNamedAndRemoveUntil(name, predicate);
    return true;
  }

  Future<dynamic> pushNamed(String name) {
    final navigator = _navigator;
    if( navigator == null ) {
      return null;
    }

    return navigator.pushNamed(name);
  }

  Future<dynamic> push(Route<dynamic> route) {
    final navigator = _navigator;
    if( navigator == null ) {
      return null;
    }

    return _navigator.push(route);
  }

  bool pop([dynamic result]) {
    final navigator = _navigator;
    if( navigator == null ) {
      return false;
    }

    navigator.pop(result);
    return true;
  }

  bool popUntil(RoutePredicate predicate) {
    final navigator = _navigator;
    if( navigator == null ) {
      return false;
    }

    navigator.popUntil(predicate);
    return true;
  }

  S initialState();
}