import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

performSelectionHaptic(BuildContext context, [bool iOSOnly = true]) {
  if( iOSOnly && Theme.of(context).platform == TargetPlatform.iOS ) {
    HapticFeedback.selectionClick();
  }
}