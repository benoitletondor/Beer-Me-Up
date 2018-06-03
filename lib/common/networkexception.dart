import 'dart:io';

class NetworkException extends IOException {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => message;
}