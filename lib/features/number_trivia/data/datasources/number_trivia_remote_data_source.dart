import 'dart:convert';

import 'package:clean_arch_reso/core/error/exceptions.dart';
import 'package:clean_arch_reso/features/number_trivia/data/models/number_trivia_model.dart';

import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int? number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  const NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int? number) async {
    final uri = Uri(path: 'numbersapi.com/$number');
    return _getTriviaFromUri(uri);
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    final uri = Uri(path: 'numbersapi.com/random');
    return _getTriviaFromUri(uri);
  }

  Future<NumberTriviaModel> _getTriviaFromUri(Uri uri) async {
    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
