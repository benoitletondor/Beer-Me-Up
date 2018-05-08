import 'package:flutter_stream_friends/flutter_stream_friends.dart';

class OnboardingSecondPageIntent {
  final VoidStreamCallback finish;

  OnboardingSecondPageIntent({
    final VoidStreamCallback finishIntent,
  }) :
    this.finish = finishIntent ?? VoidStreamCallback();
}