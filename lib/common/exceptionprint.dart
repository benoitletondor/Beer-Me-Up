import 'package:flutter/foundation.dart';

void printException(Exception e, StackTrace stackTrace, {message: String}) {
  if( message != null ) {
    debugPrint("$message: $e");
  } else {
    debugPrint(e.toString());
  }

  print(stackTrace);
}