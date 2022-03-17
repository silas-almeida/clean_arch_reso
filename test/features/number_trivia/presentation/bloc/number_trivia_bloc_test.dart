import 'package:clean_arch_reso/core/error/failures.dart';
import 'package:clean_arch_reso/core/usecases/usecase.dart';
import 'package:clean_arch_reso/core/utils/input_converter.dart';
import 'package:clean_arch_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch_reso/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arch_reso/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_arch_reso/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_MESSAGE =
    'Invalid Input: the number must be a positive integer or zero.';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomdNumberTrivia extends Mock implements GetRandomNumberTrivia {
}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc? bloc;
  MockGetConcreteNumberTrivia? mockGetConcreteNumberTrivia;
  MockGetRandomdNumberTrivia? mockGetRandomdNumberTrivia;
  MockInputConverter? mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomdNumberTrivia = MockGetRandomdNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia!,
      getRandomNumberTrivia: mockGetRandomdNumberTrivia!,
      inputConverter: mockInputConverter!,
    );
  });

  test('InitialState should be Empty', () {
    expect(bloc!.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverter() =>
        when(mockInputConverter!.stringToUnsignedInteger(tNumberString))
            .thenReturn(const Right(tNumberParsed));

    test(
        'Should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      setUpMockInputConverter();
      when(mockGetConcreteNumberTrivia!(const Params(number: tNumberParsed)))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      bloc!.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(mockInputConverter!.stringToUnsignedInteger('1'));
      verify(mockInputConverter!.stringToUnsignedInteger(tNumberString));
    });

    test('Should emit [Error] when the input is invalid', () async {
      when(mockInputConverter!.stringToUnsignedInteger(tNumberString))
          .thenReturn(Left(InvalidInputFailure()));

      expectLater(bloc!.stream,
          emits(const Error(errorMessage: INVALID_INPUT_MESSAGE)));

      bloc!.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    test('Should get data form the concrete usecase', () async {
      setUpMockInputConverter();
      when(mockGetConcreteNumberTrivia!(const Params(number: tNumberParsed)))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      bloc!.add(const GetTriviaForConcreteNumber(numberString: tNumberString));

      await untilCalled(
          mockGetConcreteNumberTrivia!(const Params(number: tNumberParsed)));

      verify(mockGetConcreteNumberTrivia!(const Params(number: tNumberParsed)));
    });

    test('Should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      setUpMockInputConverter();
      when(mockGetConcreteNumberTrivia!(const Params(number: tNumberParsed)))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      final expected = [Loading(), const Loaded(trivia: tNumberTrivia)];

      expectLater(bloc!.stream, emitsInOrder(expected));

      bloc!.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    test('Should emit [Loading, Error] when getting data fails', () async {
      setUpMockInputConverter();
      when(mockGetConcreteNumberTrivia!(const Params(number: tNumberParsed)))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        Loading(),
        const Error(errorMessage: SERVER_FAILURE_MESSAGE)
      ];

      expectLater(bloc!.stream, emitsInOrder(expected));

      bloc!.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    test(
        'Should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      setUpMockInputConverter();
      when(mockGetConcreteNumberTrivia!(const Params(number: tNumberParsed)))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        Loading(),
        const Error(errorMessage: CACHE_FAILURE_MESSAGE)
      ];

      expectLater(bloc!.stream, emitsInOrder(expected));

      bloc!.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test('Should get data form the random usecase', () async {
      when(mockGetRandomdNumberTrivia!(const NoParams()))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      bloc!.add(GetTriviaForRandomNumber());

      await untilCalled(mockGetRandomdNumberTrivia!(const NoParams()));

      verify(mockGetRandomdNumberTrivia!(const NoParams()));
    });

    test('Should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      when(mockGetRandomdNumberTrivia!(const NoParams()))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      final expected = [Loading(), const Loaded(trivia: tNumberTrivia)];

      expectLater(bloc!.stream, emitsInOrder(expected));

      bloc!.add(GetTriviaForRandomNumber());
    });

    test('Should emit [Loading, Error] when getting data fails', () async {
      when(mockGetRandomdNumberTrivia!(const NoParams()))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        Loading(),
        const Error(errorMessage: SERVER_FAILURE_MESSAGE)
      ];

      expectLater(bloc!.stream, emitsInOrder(expected));

      bloc!.add(GetTriviaForRandomNumber());
    });

    test(
        'Should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      when(mockGetRandomdNumberTrivia!(const NoParams())).thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        Loading(),
        const Error(errorMessage: CACHE_FAILURE_MESSAGE)
      ];

      expectLater(bloc!.stream, emitsInOrder(expected));

      bloc!.add(GetTriviaForRandomNumber());
    });
  });
}
