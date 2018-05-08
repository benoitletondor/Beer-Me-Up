import 'package:flutter_stream_friends/flutter_stream_friends.dart';

import 'package:beer_me_up/model/checkin.dart';

class CheckInQuantityIntent {
  final ValueStreamCallback<CheckInQuantity> quantitySelected;
  final VoidStreamCallback changeDateTime;
  final VoidStreamCallback checkInConfirmed;

  CheckInQuantityIntent({
    final ValueStreamCallback<CheckInQuantity> quantitySelectedIntent,
    final VoidStreamCallback checkInConfirmedIntent,
    final VoidStreamCallback changeDateTimeIntent,
  }) :
    this.quantitySelected = quantitySelectedIntent ?? ValueStreamCallback<CheckInQuantity>(),
    this.checkInConfirmed = checkInConfirmedIntent ?? VoidStreamCallback(),
    this.changeDateTime = changeDateTimeIntent ?? VoidStreamCallback();
}