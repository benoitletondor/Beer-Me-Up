import 'package:flutter/material.dart';

class OnboardingFirstPageIntent {
  final VoidCallback next;

  OnboardingFirstPageIntent({
    final VoidCallback nextIntent,
  }) :
    this.next = nextIntent ?? {};
}