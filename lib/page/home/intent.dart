import 'package:flutter_stream_friends/flutter_stream_friends.dart';

class HomeIntent {
  final VoidStreamCallback showProfile;
  final VoidStreamCallback showHistory;
  final VoidStreamCallback retry;
  final VoidStreamCallback beerCheckIn;
  final VoidStreamCallback showAccountPage;

  HomeIntent({
    final VoidStreamCallback showProfile,
    final VoidStreamCallback showHistory,
    final VoidStreamCallback retry,
    final VoidStreamCallback beerCheckIn,
    final VoidStreamCallback showAccountPage,
  }) :
    this.showProfile = showProfile ?? VoidStreamCallback(),
    this.showHistory = showHistory ?? VoidStreamCallback(),
    this.retry = retry ?? VoidStreamCallback(),
    this.beerCheckIn = beerCheckIn ?? VoidStreamCallback(),
    this.showAccountPage = showAccountPage ?? VoidStreamCallback();

}