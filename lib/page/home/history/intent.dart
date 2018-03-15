import 'package:flutter_stream_friends/flutter_stream_friends.dart';

class HistoryIntent {
  final VoidStreamCallback retry;

  HistoryIntent({
    final VoidStreamCallback retryIntent,
  }) :
    this.retry = retryIntent ?? new VoidStreamCallback();
}