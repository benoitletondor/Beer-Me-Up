import 'package:flutter_stream_friends/flutter_stream_friends.dart';

class HistoryIntent {
  final VoidStreamCallback retry;
  final VoidStreamCallback loadMore;

  HistoryIntent({
    final VoidStreamCallback retryIntent,
    final VoidStreamCallback loadMoreIntent,
  }) :
    this.retry = retryIntent ?? VoidStreamCallback(),
    this.loadMore = loadMoreIntent ?? VoidStreamCallback();
}