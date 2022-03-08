import 'package:clean_arch_reso/core/utils/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter? inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
        'should return an integer when the string represents and unsigned integer',
        () async {
      const str = '123';

      final result = inputConverter!.stringToUnsignedInteger(str);

      expect(result, equals(const Right(123)));
    });

    test('Should return a Failure when the string is not an integer', () {
      const str = 'ABC';

      final result = inputConverter!.stringToUnsignedInteger(str);

      expect(result, equals(Left(InvalidInputFailure())));
    });

    test('Should return a Failure when the string is a negative integer', () {
      const str = '-123';

      final result = inputConverter!.stringToUnsignedInteger(str);

      expect(result, equals(Left(InvalidInputFailure())));
    });
  });
}
