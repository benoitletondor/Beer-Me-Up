import 'package:flutter_stream_friends/flutter_stream_friends.dart';

class SettingsIntent {
  final VoidStreamCallback logout;
  final ValueStreamCallback<bool> toggleHapticFeedback;
  final ValueStreamCallback<bool> toggleAnalytics;

  SettingsIntent({
    final VoidStreamCallback logoutIntent,
    final ValueStreamCallback<bool> toggleHapticFeedbackIntent,
    final ValueStreamCallback<bool> toggleAnalyticsIntent,
  }) :
    this.logout = logoutIntent ?? VoidStreamCallback(),
    this.toggleHapticFeedback = toggleHapticFeedbackIntent ?? ValueStreamCallback<bool>(),
    this.toggleAnalytics = toggleAnalyticsIntent ?? ValueStreamCallback<bool>();
}