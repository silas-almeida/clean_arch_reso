import 'dart:convert';

import 'package:clean_arch_reso/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arch_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test text');

  test('NumberTriviaModel Should be a subclass of NumberTrivia', () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('Should return valid model when the JSON number is an integer ',
        () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, tNumberTriviaModel);
    });

    test(
        'Should return valid model when the JSON number is regarded as a double ',
        () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('Should retun a JSON map containing the proper data', () async {
      final result = tNumberTriviaModel.toJson();

      final expectedMap = {
        "text": "Test text",
        "number": 1,
      };

      expect(result, expectedMap);
      
    });
  });
}
