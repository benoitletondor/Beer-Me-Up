import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:beer_me_up/service/authenticationservice.dart';

performSelectionHaptic(BuildContext context, [bool iOSOnly = true, AuthenticationService authService]) async {
  if( iOSOnly && Theme.of(context).platform != TargetPlatform.iOS ) {
    return;
  }

  authService = authService ?? AuthenticationService.instance;
  final hapticEnabled = await authService.hapticFeedbackEnabled();

  if( hapticEnabled ) {
    HapticFeedback.selectionClick();
  }
}
