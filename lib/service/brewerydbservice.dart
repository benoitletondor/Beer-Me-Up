import 'package:meta/meta.dart';
import 'package:beer_me_up/private.dart';

abstract class BreweryDBService {
  static const _BREWERY_DB_API_ENDPOINT = "api.brewerydb.com";
  
  Uri buildBreweryDBServiceURI({
    @required String path,
    Map<String, String> queryParameters,
  }) {
    final Map<String, String> queryParams = queryParameters ?? new Map();
    queryParams.addAll({"key": BREWERY_DB_API_KEY});
    
    return new Uri.https(_BREWERY_DB_API_ENDPOINT, "/v2/$path", queryParams);
  }
}