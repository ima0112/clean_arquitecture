import 'dart:convert';

import 'package:clean_arquitecture/core/error/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

import 'package:clean_arquitecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arquitecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientSuccess404() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'should perform a GET request on a URL '
        'with number being the endpoint and with application/json header',
        () async {
      setUpMockHttpClientSuccess200();

      dataSource.getConcreteNumberTrivia(tNumber);

      var url = Uri.parse('http://numbersapi.com/$tNumber');

      verify(
          mockClient.get(url, headers: {'Content-Type': 'application/json'}));
    });

    test(
        'should return NumberTrivia '
        'with when the respond is 200 (success)', () async {
      setUpMockHttpClientSuccess200();

      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException '
        'when the respond is 404 or other', () async {
      setUpMockHttpClientSuccess404();

      final call = dataSource.getConcreteNumberTrivia;

      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'should perform a GET request on a URL '
        'with number being the endpoint and with application/json header',
        () async {
      setUpMockHttpClientSuccess200();

      dataSource.getRandomNumberTrivia();

      var url = Uri.parse('http://numbersapi.com/random');

      verify(
          mockClient.get(url, headers: {'Content-Type': 'application/json'}));
    });

    test(
        'should return NumberTrivia '
        'with when the respond is 200 (success)', () async {
      setUpMockHttpClientSuccess200();

      final result = await dataSource.getRandomNumberTrivia();

      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException '
        'when the respond is 404 or other', () async {
      setUpMockHttpClientSuccess404();

      final call = dataSource.getRandomNumberTrivia();

      expect(() => call, throwsA(TypeMatcher<ServerException>()));
    });
  });
}
