import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/exceptionprint.dart';

abstract class Config {
  static Config create() => _ConfigImpl();

  int getDefaultCheckInPoints();
  int getFirstBeerCheckInPoints();
  int getFirstWeekBeerCheckInPoints();
  int getFirstWeekCategoryCheckInPoints();
  int getFirstWeekCheckInPoints();
  String getBeerProviderKeys();
}

class _ConfigImpl implements Config {
  static const _DEFAULT_CHECKIN_POINTS_KEY = "default_checkin";
  static const _DEFAULT_DEFAULT_CHECKIN_POINTS_VALUE = 2;
  static const _FIRST_BEER_CHECKIN_POINTS_KEY = "first_beer_checkin";
  static const _DEFAULT_FIRST_BEER_CHECKIN_POINTS_VALUE = 40;
  static const _FIRST_WEEK_BEER_CHECKIN_POINTS_KEY = "first_week_beer_checkin";
  static const _DEFAULT_FIRST_WEEK_BEER_CHECKIN_POINTS_VALUE = 15;
  static const _FIRST_WEEK_CATEGORY_CHECKIN_POINTS_KEY = "first_week_category_checkin";
  static const _DEFAULT_FIRST_WEEK_CATEGORY_CHECKIN_POINTS_VALUE = 20;
  static const _FIRST_WEEK_CHECKIN_POINTS_KEY = "first_week_checkin";
  static const _DEFAULT_FIRST_WEEK_CHECKIN_POINTS_VALUE = 10;
  static const _BEER_PROVIDER_KEYS_KEY = "beer_api_keys";
  static const _DEFAULT_BEER_PROVIDER_API_VALUE = "";

  RemoteConfig _remoteConfig;

  _ConfigImpl() {
    _setupRemoteConfig();
  }

  _setupRemoteConfig() async {
    try {
      final remoteConfig = await RemoteConfig.instance;
      remoteConfig.setDefaults(<String, dynamic>{
        _DEFAULT_CHECKIN_POINTS_KEY: _DEFAULT_DEFAULT_CHECKIN_POINTS_VALUE,
        _FIRST_BEER_CHECKIN_POINTS_KEY: _DEFAULT_FIRST_BEER_CHECKIN_POINTS_VALUE,
        _FIRST_WEEK_BEER_CHECKIN_POINTS_KEY: _DEFAULT_FIRST_WEEK_BEER_CHECKIN_POINTS_VALUE,
        _FIRST_WEEK_CATEGORY_CHECKIN_POINTS_KEY: _DEFAULT_FIRST_WEEK_CATEGORY_CHECKIN_POINTS_VALUE,
        _FIRST_WEEK_CHECKIN_POINTS_KEY: _DEFAULT_FIRST_WEEK_CHECKIN_POINTS_VALUE,
        _BEER_PROVIDER_KEYS_KEY: _DEFAULT_BEER_PROVIDER_API_VALUE,
      });

      _remoteConfig = remoteConfig;

      await _remoteConfig.fetch(expiration: const Duration(hours: 1));
      await _remoteConfig.activateFetched();

      debugPrint("Remote config fetched");
    } on FetchThrottledException catch (e) {
      debugPrint("Remote config fetch throttled: $e");
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error fetching remote config");
    }
  }

  @override
  int getDefaultCheckInPoints() {
    if( _remoteConfig != null ) {
      return _remoteConfig.getInt(_DEFAULT_CHECKIN_POINTS_KEY);
    } else {
      return _DEFAULT_DEFAULT_CHECKIN_POINTS_VALUE;
    }
  }

  @override
  int getFirstBeerCheckInPoints() {
    if( _remoteConfig != null ) {
      return _remoteConfig.getInt(_FIRST_BEER_CHECKIN_POINTS_KEY);
    } else {
      return _DEFAULT_FIRST_BEER_CHECKIN_POINTS_VALUE;
    }
  }

  @override
  int getFirstWeekBeerCheckInPoints() {
    if( _remoteConfig != null ) {
      return _remoteConfig.getInt(_FIRST_WEEK_BEER_CHECKIN_POINTS_KEY);
    } else {
      return _DEFAULT_FIRST_WEEK_BEER_CHECKIN_POINTS_VALUE;
    }
  }

  @override
  int getFirstWeekCategoryCheckInPoints() {
    if( _remoteConfig != null ) {
      return _remoteConfig.getInt(_FIRST_WEEK_CATEGORY_CHECKIN_POINTS_KEY);
    } else {
      return _DEFAULT_FIRST_WEEK_CATEGORY_CHECKIN_POINTS_VALUE;
    }
  }

  @override
  int getFirstWeekCheckInPoints() {
    if( _remoteConfig != null ) {
      return _remoteConfig.getInt(_FIRST_WEEK_CHECKIN_POINTS_KEY);
    } else {
      return _DEFAULT_FIRST_WEEK_CHECKIN_POINTS_VALUE;
    }
  }

  @override
  String getBeerProviderKeys() {
    if( _remoteConfig != null ) {
      return _remoteConfig.getString(_BEER_PROVIDER_KEYS_KEY);
    } else {
      return _DEFAULT_BEER_PROVIDER_API_VALUE;
    }
  }

}