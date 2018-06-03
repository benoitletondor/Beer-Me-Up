import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:beer_me_up/model/beer.dart';
import 'package:meta/meta.dart';
import 'package:beer_me_up/private.dart';
import 'package:beer_me_up/service/beersearch/beersearchservice.dart';

class UntappdService implements BeerSearchService {
  static const _UNTAPPD_DB_API_ENDPOINT = "api.untappd.com";

  static Uri _buildUntappdServiceURI({
    @required String path,
    Map<String, String> queryParameters,
  }) {
    final Map<String, String> queryParams = queryParameters ?? Map();

    if( Platform.isIOS ) {
      queryParams.addAll({"client_secret": UNTAPPD_CLIENT_SECRET_IOS, "client_id": UNTAPPD_CLIENT_ID_IOS});
    } else {
      queryParams.addAll({"client_secret": UNTAPPD_CLIENT_SECRET_ANDROID, "client_id": UNTAPPD_CLIENT_ID_ANDROID});
    }

    return Uri.https(_UNTAPPD_DB_API_ENDPOINT, "/v4/$path", queryParams);
  }

  @override
  Future<List<Beer>> findBeersMatching(HttpClient httpClient, String pattern) async {
    if( pattern == null || pattern.trim().isEmpty ) {
      return List(0);
    }

    var uri = _buildUntappdServiceURI(path: "search/beer", queryParameters: {'q': pattern, 'limit': '50'});
    HttpClientRequest request = await httpClient.getUrl(uri);
    HttpClientResponse response = await request.close();
    if( response.statusCode <200 || response.statusCode>299 ) {
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