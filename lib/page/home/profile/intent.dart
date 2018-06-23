import 'package:flutter_stream_friends/flutter_stream_friends.dart';

import 'package:beer_me_up/model/checkin.dart';

class ProfileIntent {
  final VoidStreamCallback retry;
  final ValueStreamCallback<CheckIn> rateCheckIn;

  ProfileIntent({
    final VoidStreamCallback retryIntent,
    final ValueStreamCallback<CheckIn> rateCheckInIntent,
  }) :
    this.retry = retryIntent ?? VoidStreamCallback(),
    this.rateCheckIn = rateCheckInIntent ?? ValueStreamCallback<CheckIn>();
}