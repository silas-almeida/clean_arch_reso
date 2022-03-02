import 'dart:convert';

import 'package:clean_arch_reso/core/error/exceptions.dart';
import 'package:clean_arch_reso/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arch_reso/features/number_trivia/data/models/number_trivia_model.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl? dataSource;
  MockHttpClient? mockHttpClient;

  const tNumber = 1;
  const path = 'numbersapi.com/$tNumber';
  const randomNumberPath = 'numbersapi.com/random';
  final Uri mockedConcreteURI = Uri(
    path: path,
  );

  final Uri mockedRandomURI = Uri(path: randomNumberPath);
  final tNumberTriviaModel =
      NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient!);
  });

  void setUpMockHttpClientSuccess(Uri uri) {
    when(mockHttpClient!.get(uri, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure(Uri uri) {
    when(mockHttpClient!.get(uri, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    test(
      'should perform a GET request on a URL with given number being the endpoint and with application/json header',
      () async {
        setUpMockHttpClientSuccess(mockedConcreteURI);

        dataSource!.getConcreteNumberTrivia(tNumber);

        verify(
          mockHttpClient!.get(mockedConcreteURI,
              headers: {'Content-Type': 'application/json'}),
        );
      },
    );

    test('Should return NumberTrivia when the response code is 200 (success)',
        () async {
      setUpMockHttpClientSuccess(mockedConcreteURI);

      final result = await dataSource!.getConcreteNumberTrivia(tNumber);

      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      setUpMockHttpClientFailure(mockedConcreteURI);

      final call = dataSource!.getConcreteNumberTrivia;

      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    test(
      'should perform a GET request on a URL with given number being the endpoint and with application/json header',
      () async {
        setUpMockHttpClientSuccess(mockedRandomURI);

        dataSource!.getRandomNumberTrivia();

        verify(
          mockHttpClient!.get(mockedRandomURI,
              headers: {'Content-Type': 'application/json'}),
        );
      },
    );

    test('Should return NumberTrivia when the response code is 200 (success)',
        () async {
      setUpMockHttpClientSuccess(mockedRandomURI);

      final result = await dataSource!.getRandomNumberTrivia();

      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      setUpMockHttpClientFailure(mockedRandomURI);

      final call = dataSource!.getRandomNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
