import 'package:flutter_stream_friends/flutter_stream_friends.dart';

import 'package:beer_me_up/model/checkin.dart';

class CheckInConfirmIntent {
  final ValueStreamCallback<CheckInQuantity> quantitySelected;
  final VoidStreamCallback changeDateTime;
  final VoidStreamCallback checkInConfirmed;
  final VoidStreamCallback retry;

  CheckInConfirmIntent({
    final ValueStreamCallback<CheckInQuantity> quantitySelectedIntent,
    final VoidStreamCallback checkInConfirmedIntent,
    final VoidStreamCallback changeDateTimeIntent,
    final VoidStreamCallback retryIntent,
  }) :
    this.quantitySelected = quantitySelectedIntent ?? ValueStreamCallback<CheckInQuantity>(),
    this.checkInConfirmed = checkInConfirmedIntent ?? VoidStreamCallback(),
    this.changeDateTime = changeDateTimeIntent ?? VoidStreamCallback(),
    this.retry = retryIntent ?? VoidStreamCallback();
}