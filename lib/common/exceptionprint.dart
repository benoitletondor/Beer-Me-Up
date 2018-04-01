import 'package:flutter/foundation.dart';

void printException(dynamic e, StackTrace stackTrace, {message: String}) {
  if( message != null ) {
    debugPrint("$message: $e");
  } else {
    debugPrint(e.toString());
  }

  print(stackTrace);
}