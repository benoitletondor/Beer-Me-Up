import 'package:meta/meta.dart';
import 'package:beer_me_up/private.dart';
import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/service/beersearch/beersearchservice.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class BreweryDBService implements BeerSearchService {
  static const _BREWERY_DB_API_ENDPOINT = "api.brewerydb.com";
  
  static Uri _buildBreweryDBServiceURI({
    @required String path,
    Map<String, String> queryParameters,
  }) {
    final Map<String, String> queryParams = queryParameters ?? Map();
    queryParams.addAll({"key": BREWERY_DB_API_KEY});
    
    return Uri.https(_BREWERY_DB_API_ENDPOINT, "/v2/$path", queryParams);
  }

  @override
  Future<List<Beer>> findBeersMatching(HttpClient httpClient, String pattern) async {
    if( pattern == null || pattern.trim().isEmpty ) {
      return List(0);
    }

    var uri = _buildBreweryDBServiceURI(path: "search", queryParameters: {'q': pattern, 'type': 'beer'});
    HttpClientRequest request = await httpClient.getUrl(uri);
    HttpClientResponse response = await request.close();
    if( response.statusCode <200 || response.statusCode>299 ) {
      throw Exception("Bad response: ${response.statusCode} (${response.reasonPhrase})");
    }

    String responseBody = await response.transform(utf8.decoder).join();
    Map data = json.decode(responseBody);
    int totalResults = data["totalResults"] ?? 0;
    if( totalResults == 0 ) {
      return List(0);
    }

    return (data['data'] as List).map((beerJson) {
      BeerStyle style;

      final Map<dynamic, dynamic> styleData = beerJson["style"];
      if( styleData != null ) {
        style = BeerStyle(
          id: (styleData["id"] as int).toString(),
          name: styleData["shortname"] ?? styleData["name"],
        );
      }

      double abv;
      if( beerJson["abv"] != null ) {
        abv = double.parse(beerJson["abv"] as String);
      } else if( styleData != null ) {
        final String abvMin = styleData["abvMin"];
        final String abvMax = styleData["abvMax"];

        if( abvMax != null && abvMin != null ) {
          abv = (double.parse(abvMax) + double.parse(abvMin)) / 2.0;
        } else if( abvMin != null ) {
          abv = double.parse(abvMin);
        } else if( abvMax != null ) {
          abv = double.parse(abvMax);
        }
      }

      BeerLabel label;
      final labelJson = beerJson["labels"];
      if( labelJson != null && labelJson is Map ) {
        label = BeerLabel(
          iconUrl: labelJson["icon"],
          mediumUrl: labelJson["medium"],
          largeUrl: labelJson["large"],
        );
      }

      return Beer(
        id: beerJson["id"],
        name: beerJson["name"],
        description: beerJson["description"],
        abv: abv,
        label: label,
        style: style,
      );
    }).toList(growable: false);
  }


}