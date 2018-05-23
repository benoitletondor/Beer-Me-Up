import 'package:flutter/foundation.dart';
import 'package:beer_me_up/main.dart';
import 'package:sentry/sentry.dart';

void printException(dynamic e, StackTrace stackTrace, [String message]) {
  if( message != null ) {
    debugPrint("$message: $e");
  } else {
    debugPrint(e.toString());
  }

  final Event event = new Event(
    exception: e,
    stackTrace: stackTrace,
    message: message,
  );
  BeerMeUpApp.sentry.capture(event: event);

  print(stackTrace);
}