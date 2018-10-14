import 'package:flutter_stream_friends/flutter_stream_friends.dart';

import 'package:beer_me_up/model/checkin.dart';
import 'package:beer_me_up/model/beer.dart';

class ProfileIntent {
  final VoidStreamCallback retry;
  final ValueStreamCallback<CheckIn> rateCheckIn;
  final ValueStreamCallback<Beer> beerDetails;
  final VoidStreamCallback hideCheckInRating;

  ProfileIntent({
    final VoidStreamCallback retryIntent,
    final ValueStreamCallback<CheckIn> rateCheckInIntent,
    final ValueStreamCallback<Beer> beerDetailsIntent,
    final VoidStreamCallback hideCheckInRatingIntent,
  }) :
    this.retry = retryIntent ?? VoidStreamCallback(),
    this.rateCheckIn = rateCheckInIntent ?? ValueStreamCallback<CheckIn>(),
    this.beerDetails = beerDetailsIntent ?? ValueStreamCallback<Beer>(),
    this.hideCheckInRating = hideCheckInRatingIntent ?? VoidStreamCallback();
}