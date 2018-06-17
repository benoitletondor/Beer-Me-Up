import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:beer_me_up/main.dart';
import 'package:beer_me_up/service/authenticationservice.dart';
import 'package:sentry/sentry.dart';

void printException(dynamic e, StackTrace stackTrace, [String message]) {
  if( message != null ) {
    debugPrint("$message: $e");
  } else {
    debugPrint(e.toString());
  }

  if( !(e is IOException) && !(e is AuthCancelledException) && !_isFirestoreIOException(e) ) {
    final Event event = new Event(
      exception: e,
      stackTrace: stackTrace,
      message: message,
    );
    BeerMeUpApp.sentry.capture(event: event);
  }

  print(stackTrace);
}

bool _isFirestoreIOException(dynamic e) {
  return e.toString().contains("because the client is offline");
}