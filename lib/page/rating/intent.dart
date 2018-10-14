import 'package:flutter_stream_friends/flutter_stream_friends.dart';

class RatingIntent {
  final ValueStreamCallback<int> rate;
  final VoidStreamCallback retryLoadRating;

  RatingIntent({
    final ValueStreamCallback<bool> rateIntent,
    final VoidStreamCallback retryLoadRatingIntent,
  }) :
    this.rate = rateIntent ?? ValueStreamCallback<int>(),
    this.retryLoadRating = retryLoadRatingIntent ?? VoidStreamCallback();
}