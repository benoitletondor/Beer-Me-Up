import 'package:flutter_stream_friends/flutter_stream_friends.dart';

class ProfileIntent {
  final VoidStreamCallback retry;

  ProfileIntent({
    final VoidStreamCallback retryIntent,
  }) :
    this.retry = retryIntent ?? new VoidStreamCallback();
}