import 'package:flutter_stream_friends/flutter_stream_friends.dart';

import 'package:beer_me_up/model/checkin.dart';

class HistoryIntent {
  final VoidStreamCallback retry;
  final VoidStreamCallback loadMore;
  final ValueStreamCallback<CheckIn> checkInTapped;

  HistoryIntent({
    final VoidStreamCallback retryIntent,
    final VoidStreamCallback loadMoreIntent,
    final ValueStreamCallback<CheckIn> checkInTappedIntent,
  }) :
    this.retry = retryIntent ?? VoidStreamCallback(),
    this.loadMore = loadMoreIntent ?? VoidStreamCallback(),
    this.checkInTapped = checkInTappedIntent ?? ValueStreamCallback();
}