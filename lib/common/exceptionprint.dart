import 'package:flutter/foundation.dart';

void printException(dynamic e, StackTrace stackTrace, [String message]) {
  if( message != null ) {
    debugPrint("$message: $e");
  } else {
    debugPrint(e.toString());
  }

  print(stackTrace);
}