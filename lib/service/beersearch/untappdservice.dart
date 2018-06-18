import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:sentry/sentry.dart';

import 'package:beer_me_up/common/exceptionprint.dart';
import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/service/config.dart';
import 'package:beer_me_up/private.dart';
import 'package:beer_me_up/main.dart';
import 'package:beer_me_up/service/beersearch/beersearchservice.dart';

class UntappdService implements BeerSearchService {
  static const _UNTAPPD_DB_API_ENDPOINT = "api.untappd.com";
  static const _MAX_TRY_BEFORE_FAIL = 3;

  final Config _config;
  final List<String> _keysExcludedIds = List();
  final Random _random = Random();

  UntappdService(this._config);

  Tuple2<Uri, String> _buildUntappdServiceURI({
    @required String path,
    @required int retryCount,
    Map<String, String> queryParameters,
  }) {
    final Map<String, String> queryParams = queryParameters ?? Map();
    final Tuple2<String, String> keys = getProviderKeys(retryCount >= _MAX_TRY_BEFORE_FAIL);

    queryParams.addAll({"client_secret": keys.item2, "client_id": keys.item1});

    return Tuple2(Uri.https(_UNTAPPD_DB_API_ENDPOINT, "/v4/$path", queryParams), keys.item1);
  }

  Tuple2<String, String> getProviderKeys(bool defaultOnly) {
    if( Platform.isIOS && !_keysExcludedIds.contains(UNTAPPD_CLIENT_ID_IOS) ) {
      return Tuple2(UNTAPPD_CLIENT_ID_IOS, UNTAPPD_CLIENT_SECRET_IOS);
    } else if( !_keysExcludedIds.contains(UNTAPPD_CLIENT_ID_ANDROID) ){
      return Tuple2(UNTAPPD_CLIENT_ID_ANDROID, UNTAPPD_CLIENT_SECRET_ANDROID);
    }

    try {
      if( !defaultOnly ) {
        final String configKeys = _config.getBeerProviderKeys();
        if( configKeys != null && configKeys.isNotEmpty ) {
          List<dynamic> data = json.decode(configKeys);
          List<Map<String, dynamic>> typedData = data.map((dynamic entry) {
            return entry as Map<String, dynamic>;
          }).toList(growable: true);
          typedData.removeWhere((Map<String, dynamic> key) =>  _keysExcludedIds.contains(key["i"]));

          if( typedData.isNotEmpty ) {
            final index = _random.nextInt(typedData.length);
            return Tuple2(typedData[index]["i"], typedData[index]["s"]);
          }
        }
      }
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error getting provider keys");
    }

    if( Platform.isIOS ) {
      return Tuple2(UNTAPPD_CLIENT_ID_IOS, UNTAPPD_CLIENT_SECRET_IOS);
    } else {
      return Tuple2(UNTAPPD_CLIENT_ID_ANDROID, UNTAPPD_CLIENT_SECRET_ANDROID);
    }
  }

  @override
  Future<List<Beer>> findBeersMatching(HttpClient httpClient, String pattern) async {
    return _callApi(httpClient, pattern, 1);
  }

  Future<List<Beer>> _callApi(HttpClient httpClient, String pattern, int retryCount) async {
    if( pattern == null || pattern.trim().isEmpty ) {
      return List(0);
    }

    final serviceUri = _buildUntappdServiceURI(
      path: "search/beer",
      queryParameters: {'q': pattern, 'limit': '50'},
      retryCount: retryCount
    );

    HttpClientRequest request = await httpClient.getUrl(serviceUri.item1);
    HttpClientResponse response = await request.close();
    if( response.statusCode <200 || response.statusCode>299 ) {
      if( retryCount < _MAX_TRY_BEFORE_FAIL ) {
        BeerMeUpApp.sentry.capture(event: Event(message: "Invalid provider id: ${serviceUri.item2}"));
        _keysExcludedIds.add(serviceUri.item2);

        return _callApi(httpClient, pattern, retryCount + 1);
      }

      throw Exception("Bad response: ${response.statusCode} (${response.reasonPhrase})");
    }

    String responseBody = await response.transform(utf8.decoder).join();
    Map data = json.decode(responseBody);
    final Map<String, dynamic> responseJson = data["response"];
    int totalResults = responseJson["found"] ?? 0;
    if( totalResults == 0 ) {
      return List(0);
    }

    return (responseJson['beers']['items'] as List).map((beerJsonObject) {
      final Map<String, dynamic> beerJson = beerJsonObject["beer"];
      BeerStyle style;

      final String styleName = beerJson["beer_style"];
      if( styleName != null ) {
        style = BeerStyle(
          id: styleName,
          name: styleName,
        );
      }

      double abv;
      if( beerJson["beer_abv"] != null ) {
        if( beerJson["beer_abv"] is double ) {
          abv = beerJson["beer_abv"];
        } else if( beerJson["beer_abv"] is int ) {
          abv = (beerJson["beer_abv"] as int).toDouble();
        }
      }

      BeerLabel label;
      if( beerJson["beer_label"] != null ) {
        label = BeerLabel(
          iconUrl: beerJson["beer_label"],
        );
      }

      return Beer(
        id: (beerJson["bid"] as int).toString(),
        name: beerJson["beer_name"],
        description: beerJson["beer_description"],
        abv: abv,
        label: label,
        style: style,
      );
    }).toList(growable: false);
  }
}