import 'dart:convert';

import 'package:clean_arquitecture/core/error/exceptions.dart';
import 'package:http/http.dart' as http;

import 'package:clean_arquitecture/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    var url = Uri.parse('http://numbersapi.com/$number');
    return await _getNumberTrivia(url);
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    var url = Uri.parse('http://numbersapi.com/random');
    return await _getNumberTrivia(url);
  }

  Future<NumberTriviaModel> _getNumberTrivia(Uri url) async {
    final response =
        await client.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
