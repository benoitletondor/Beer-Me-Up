import 'dart:async';
import 'package:meta/meta.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
export 'package:firebase_analytics/firebase_analytics.dart';
export 'package:firebase_analytics/observer.dart';

import 'package:beer_me_up/service/authenticationservice.dart';

class OptOutAwareFirebaseAnalytics implements FirebaseAnalytics {
  final FirebaseAnalytics _wrapped;
  final AuthenticationService _authService;

  OptOutAwareFirebaseAnalytics(this._wrapped, [this._authService]);

  @override
  FirebaseAnalyticsAndroid get android => _wrapped.android;

  @override
  Future<Null> logEvent(
      {@required String name, Map<String, dynamic> parameters}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logEvent(name: name, parameters: parameters);
    }

    return null;
  }

  @override
  Future<Null> logViewSearchResults({@required String searchTerm}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logViewSearchResults(searchTerm: searchTerm);
    }

    return null;
  }

  @override
  Future<Null> logViewItemList({@required String itemCategory}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logViewItemList(itemCategory: itemCategory);
    }

    return null;
  }

  @override
  Future<Null> logViewItem(
      {@required String itemId, @required String itemName, @required String itemCategory, String itemLocationId, double price, int quantity, String currency, double value, String flightNumber, int numberOfPassengers, int numberOfNights, int numberOfRooms, String origin, String destination, String startDate, String endDate, String searchTerm, String travelClass}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logViewItem(itemId: itemId, itemName: itemName, itemCategory: itemCategory, itemLocationId: itemLocationId, price: price, quantity: quantity, currency: currency, value: value, flightNumber: flightNumber, numberOfPassengers: numberOfPassengers, numberOfNights: numberOfNights, numberOfRooms: numberOfRooms, origin: origin, destination: destination, startDate: startDate, endDate: endDate, searchTerm: searchTerm, travelClass: travelClass);
    }

    return null;
  }

  @override
  Future<Null> logUnlockAchievement({@required String id}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logUnlockAchievement(id: id);
    }

    return null;
  }

  @override
  Future<Null> logTutorialComplete() async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logTutorialComplete();
    }

    return null;
  }

  @override
  Future<Null> logTutorialBegin() async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logTutorialBegin();
    }

    return null;
  }

  @override
  Future<Null> logSpendVirtualCurrency(
      {@required String itemName, @required String virtualCurrencyName, @required num value}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logSpendVirtualCurrency(itemName: itemName, virtualCurrencyName: virtualCurrencyName, value: value);
    }

    return null;
  }

  @override
  Future<Null> logSignUp({@required String signUpMethod}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logSignUp(signUpMethod: signUpMethod);
    }

    return null;
  }

  @override
  Future<Null> logShare(
      {@required String contentType, @required String itemId}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logShare(contentType: contentType, itemId: itemId);
    }

    return null;
  }

  @override
  Future<Null> logSelectContent(
      {@required String contentType, @required String itemId}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logSelectContent(contentType: contentType, itemId: itemId);
    }

    return null;
  }

  @override
  Future<Null> logSearch(
      {@required String searchTerm, int numberOfNights, int numberOfRooms, int numberOfPassengers, String origin, String destination, String startDate, String endDate, String travelClass}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logSearch(searchTerm: searchTerm, numberOfNights: numberOfNights, numberOfRooms: numberOfRooms, numberOfPassengers: numberOfPassengers, origin: origin, destination: destination, startDate: startDate, endDate: endDate, travelClass: travelClass);
    }

    return null;
  }

  @override
  Future<Null> logPurchaseRefund(
      {String currency, double value, String transactionId}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logPurchaseRefund(currency: currency, value: value, transactionId: transactionId);
    }

    return null;
  }

  @override
  Future<Null> logPresentOffer(
      {@required String itemId, @required String itemName, @required String itemCategory, @required int quantity, double price, double value, String currency, String itemLocationId}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logPresentOffer(itemId: itemId, itemName: itemName, itemCategory: itemCategory, quantity: quantity, price: price, value: value, currency: currency, itemLocationId: itemLocationId);
    }

    return null;
  }

  @override
  Future<Null> logPostScore(
      {@required int score, int level, String character}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logPostScore(score: score, level: level, character: character);
    }

    return null;
  }

  @override
  Future<Null> logLogin() async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logLogin();
    }

    return null;
  }

  @override
  Future<Null> logLevelUp({@required int level, String character}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logLevelUp(level: level, character: character);
    }

    return null;
  }

  @override
  Future<Null> logJoinGroup({@required String groupId}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logJoinGroup(groupId: groupId);
    }

    return null;
  }

  @override
  Future<Null> logGenerateLead({String currency, double value}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logGenerateLead(currency: currency, value: value);
    }

    return null;
  }

  @override
  Future<Null> logEcommercePurchase(
      {String currency, double value, String transactionId, double tax, double shipping, String coupon, String location, int numberOfNights, int numberOfRooms, int numberOfPassengers, String origin, String destination, String startDate, String endDate, String travelClass}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logEcommercePurchase(currency: currency, value: value, transactionId: transactionId, tax: tax, shipping: shipping, coupon: coupon, location: location, numberOfNights: numberOfNights, numberOfRooms: numberOfRooms, numberOfPassengers: numberOfPassengers, origin: origin, destination: destination, startDate: startDate, endDate: endDate, travelClass: travelClass);
    }

    return null;
  }

  @override
  Future<Null> logEarnVirtualCurrency(
      {@required String virtualCurrencyName, @required num value}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logEarnVirtualCurrency(virtualCurrencyName: virtualCurrencyName, value: value);
    }

    return null;
  }

  @override
  Future<Null> logCampaignDetails(
      {@required String source, @required String medium, @required String campaign, String term, String content, String aclid, String cp1}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logCampaignDetails(source: source, medium: medium, campaign: campaign, term: term, content: content, aclid: aclid, cp1: cp1);
    }

    return null;
  }

  @override
  Future<Null> logBeginCheckout(
      {double value, String currency, String transactionId, int numberOfNights, int numberOfRooms, int numberOfPassengers, String origin, String destination, String startDate, String endDate, String travelClass}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logBeginCheckout(value: value, currency: currency, transactionId: travelClass, numberOfNights: numberOfNights, numberOfRooms: numberOfRooms, numberOfPassengers: numberOfPassengers, origin: origin, destination: destination, startDate: startDate, endDate: endDate, travelClass: travelClass);
    }

    return null;
  }

  @override
  Future<Null> logAppOpen() async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logAppOpen();
    }

    return null;
  }

  @override
  Future<Null> logAddToWishlist(
      {@required String itemId, @required String itemName, @required String itemCategory, @required int quantity, double price, double value, String currency, String itemLocationId}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logAddToWishlist(itemId: itemId, itemName: itemName, itemCategory: itemCategory, quantity: quantity, price: price, value: value, currency: currency, itemLocationId: itemCategory);
    }

    return null;
  }

  @override
  Future<Null> logAddToCart(
      {@required String itemId, @required String itemName, @required String itemCategory, @required int quantity, double price, double value, String currency, String origin, String itemLocationId, String destination, String startDate, String endDate}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logAddToCart(itemId: itemCategory, itemName: itemName, itemCategory: itemCategory, quantity: quantity, price: price, value: value, currency: currency, origin: origin, itemLocationId: itemLocationId, destination: destination, startDate: startDate, endDate: endDate);
    }

    return null;
  }

  @override
  Future<Null> logAddPaymentInfo() async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.logAddPaymentInfo();
    }

    return null;
  }

  @override
  Future<Null> setUserProperty(
      {@required String name, @required String value}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.setUserProperty(name: name, value: value);
    }

    return null;
  }

  @override
  Future<Null> setCurrentScreen(
      {@required String screenName, String screenClassOverride: 'Flutter'}) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.setCurrentScreen(screenName: screenName, screenClassOverride: screenClassOverride);
    }

    return null;
  }

  @override
  Future<Null> setUserId(String id) async {
    if( await _shouldTrackUser() ) {
      return await _wrapped.setUserId(id);
    }

    return null;
  }

// ----------------------------------->

  Future<bool> _shouldTrackUser() async {
    return await (_authService != null ? _authService.analyticsEnabled() : AuthenticationService.instance.analyticsEnabled());
  }
}