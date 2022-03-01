import 'package:clean_arch_reso/core/error/exceptions.dart';
import 'package:clean_arch_reso/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_arch_reso/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  // ignore: constant_identifier_names
  const String _MOCKED_CACHED_TRIVIA_PATH = 'trivia_cached.json';

  NumberTriviaLocalDataSourceImpl? dataSource;
  MockSharedPreferences? mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences!);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
        json.decode(fixture(_MOCKED_CACHED_TRIVIA_PATH)));
    test(
        'should return NumberTrivia form SharedPreferences when there is one in the cache',
        () async {
      when(mockSharedPreferences!.getString(CACHED_NUMBER_TRIVIA))
          .thenReturn(fixture(_MOCKED_CACHED_TRIVIA_PATH));

      final result = await dataSource!.getLastNumberTrivia();

      verify(mockSharedPreferences!.getString(CACHED_NUMBER_TRIVIA));

      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a CacheException when there is not a cached value',
        () async {
      when(mockSharedPreferences!.getString(CACHED_NUMBER_TRIVIA))
          .thenReturn(null);

      final call = dataSource!.getLastNumberTrivia;

      expect(call, throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    const _tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 1);
    test('Should call SharedPreferences to cache data', () async {
      dataSource!.cacheNumberTrivia(_tNumberTriviaModel);

      final expectedJsonString = json.encode(_tNumberTriviaModel.toJson());

      verify(mockSharedPreferences!.setString(CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
