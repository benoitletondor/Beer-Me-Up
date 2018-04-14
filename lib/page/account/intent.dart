import 'package:flutter_stream_friends/flutter_stream_friends.dart';

class AccountIntent {
  final VoidStreamCallback logout;

  AccountIntent({
    final VoidStreamCallback logoutIntent,
  }) :
    this.logout = logoutIntent ?? new VoidStreamCallback();
}