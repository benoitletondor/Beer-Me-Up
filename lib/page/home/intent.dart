import 'package:flutter_stream_friends/flutter_stream_friends.dart';

class HomeIntent {
  final VoidStreamCallback showProfile;
  final VoidStreamCallback showHistory;
  final VoidStreamCallback retry;
  final VoidStreamCallback beerCheckIn;

  HomeIntent({
    final VoidStreamCallback showProfile,
    final VoidStreamCallback showHistory,
    final VoidStreamCallback retry,
    final VoidStreamCallback beerCheckIn,
  }) :
    this.showProfile = showProfile ?? new VoidStreamCallback(),
    this.showHistory = showHistory ?? new VoidStreamCallback(),
    this.retry = retry ?? new VoidStreamCallback(),
    this.beerCheckIn = beerCheckIn ?? new VoidStreamCallback();

}