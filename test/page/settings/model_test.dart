import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:flutter/src/widgets/navigator.dart';
import 'package:test/test.dart';
import 'dart:async';
import 'package:async/async.dart';
import 'package:mockito/mockito.dart';

import 'package:beer_me_up/page/settings/model.dart';
import 'package:beer_me_up/page/settings/state.dart';
import 'package:beer_me_up/page/tos/tospage.dart';
import 'package:beer_me_up/service/authenticationservice.dart';

void main() {

  test('test that loading is displayed when view starts', () {
    final items = _createTestItems();

    expect(items.stateStream, emits(SettingsState.loading()));
  });

  test('test user configuration values loading and display', () {
    final analyticsEnabledList = [true, false];
    final hapticFeedbackEnabledList = [true, false];
    final emailList = ["email@unittest.com", "", null];

    for(var analyticsEnabled in analyticsEnabledList) {
      for(var hapticFeedbackEnabled in hapticFeedbackEnabledList) {
        for(var email in emailList) {
          final items = _createTestItems(
            analyticsEnabled: analyticsEnabled,
            hapticFeedbackEnabled: hapticFeedbackEnabled,
            email: email,
          );

          expect(items.stateStream, emitsThrough(
            SettingsState.load(email, hapticFeedbackEnabled, analyticsEnabled),
          ));
        }
      }
    }
  });


  test('test analytics enabled change is sent to the UI', () async {
    final email = "email";
    final items = _createTestItems(
      analyticsEnabled: true,
      hapticFeedbackEnabled: true,
      email: email,
    );

    await expectLater(items.stateStream, emitsThrough(
      SettingsState.load(email, true, true)
    ));

    items.analyticsSettingStream.add(false);
    expect(await items.stateStream.next, SettingsState.load(email, true, false));
    verify(items.authService.setAnalyticsEnabled(false));

    items.analyticsSettingStream.add(true);
    expect(await items.stateStream.next, SettingsState.load(email, true, true));
    verify(items.authService.setAnalyticsEnabled(true));
  });

  test('test haptic feedback enabled change is sent to the UI', () async {
    final email = "email";
    final items = _createTestItems(
      analyticsEnabled: true,
      hapticFeedbackEnabled: true,
      email: email,
    );

    await expectLater(items.stateStream, emitsThrough(
        SettingsState.load(email, true, true)
    ));

    items.hapticFeedbackSettingStream.add(false);
    expect(await items.stateStream.next, SettingsState.load(email, false, true));
    verify(items.authService.setHapticFeedbackEnabled(false));

    items.hapticFeedbackSettingStream.add(true);
    expect(await items.stateStream.next, SettingsState.load(email, true, true));
    verify(items.authService.setHapticFeedbackEnabled(true));
  });

  test('clicking on ToS button push the ToS page', () async {
    final items = _createTestItems(
      analyticsEnabled: true,
      hapticFeedbackEnabled: true,
      email: "test",
    );

    await expectLater(items.stateStream, emitsThrough(
        SettingsState.load("test", true, true)
    ));

    items.tosButtonStream.add(null);
    verify(items.navigator.pushNamed(TOS_PAGE_ROUTE));
  });

  test('clicking on logout button logs the user out', () async {
    final items = _createTestItems(
      analyticsEnabled: true,
      hapticFeedbackEnabled: true,
      email: "test",
    );

    await expectLater(items.stateStream, emitsThrough(
        SettingsState.load("test", true, true)
    ));

    items.logoutButtonStream.add(null);

    verify(items.authService.signOut());
  });
}

TestItems _createTestItems({
  bool analyticsEnabled: true,
  bool hapticFeedbackEnabled: false,
  String email : "email@test.com",
}) {
  final authService = _MockAuthService();
  final logoutButtonStream = StreamController<Null>(sync: true);
  final hapticFeedbackSettingStream = StreamController<bool>(sync: true);
  final analyticsSettingStream = StreamController<bool>(sync: true);
  final tosButtonStream = StreamController<Null>(sync: true);

  final viewModel = SettingsViewModel(
    authService,
    logoutButtonStream.stream,
    hapticFeedbackSettingStream.stream,
    analyticsSettingStream.stream,
    tosButtonStream.stream,
  );

  when(authService.analyticsEnabled()).thenAnswer((_) => Future.value(analyticsEnabled));
  when(authService.hapticFeedbackEnabled()).thenAnswer((_) => Future.value(hapticFeedbackEnabled));
  when(authService.setHapticFeedbackEnabled(any)).thenAnswer((_) => Future.value(Null));
  when(authService.setAnalyticsEnabled(any)).thenAnswer((_) => Future.value(Null));
  when(authService.getCurrentUser()).thenAnswer((_) => Future.value(_MockUser(email)));
  when(authService.signOut()).thenAnswer((_) => Future.value(Null));

  final stateStream = viewModel.bind(null);

  final navigator = _MockNavigator();
  viewModel.setNavigator(navigator);

  return TestItems(
      StreamQueue(stateStream),
      navigator,
      authService,
      logoutButtonStream,
      hapticFeedbackSettingStream,
      analyticsSettingStream,
      tosButtonStream
  );
}

class _MockAuthService extends Mock implements AuthenticationService {}

class _MockNavigator extends Mock implements NavigatorState {
  @override
  String toString ({
    DiagnosticLevel minLevel: DiagnosticLevel.debug
  }) { return null; }
}

class _MockUser extends Mock implements FirebaseUser {
  @override
  final String email;

  _MockUser(this.email);
}

class TestItems {
  final StreamQueue<SettingsState> stateStream;
  final NavigatorState navigator;
  final AuthenticationService authService;
  final StreamController<Null> logoutButtonStream;
  final StreamController<bool> hapticFeedbackSettingStream;
  final StreamController<bool> analyticsSettingStream;
  final StreamController<Null> tosButtonStream;

  TestItems(
    this.stateStream,
    this.navigator,
    this.authService,
    this.logoutButtonStream,
    this.hapticFeedbackSettingStream,
    this.analyticsSettingStream,
    this.tosButtonStream,
  );
}