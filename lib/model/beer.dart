import 'package:meta/meta.dart';

class Beer {
  final String id;
  final String name;
  final String description;
  final String thumbnailUrl;

  Beer({
    @required this.id,
    @required this.name,
    @required this.description,
    this.thumbnailUrl,
  });
}