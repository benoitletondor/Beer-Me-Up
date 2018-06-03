import 'package:beer_me_up/model/beer.dart';
import 'dart:async';
import 'dart:io';

abstract class BeerSearchService {
  Future<List<Beer>> findBeersMatching(HttpClient httpClient, String pattern);
}