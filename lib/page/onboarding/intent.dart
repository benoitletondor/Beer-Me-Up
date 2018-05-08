import 'package:flutter_stream_friends/flutter_stream_friends.dart';

class OnboardingIntent {
  final VoidStreamCallback finish;

  OnboardingIntent({
    final VoidStreamCallback finishIntent,
  }) :
    this.finish = finishIntent ?? VoidStreamCallback();
}