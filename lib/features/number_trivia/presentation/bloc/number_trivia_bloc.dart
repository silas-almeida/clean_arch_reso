import 'package:bloc/bloc.dart';
import 'package:clean_arch_reso/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_MESSAGE =
    'Invalid Input: the number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaForConcreteNumber) {
        final inputEither =
            inputConverter.stringToUnsignedInteger(event.numberString);
        inputEither!.fold(
          (failure) async =>
              emit(const Error(errorMessage: INVALID_INPUT_MESSAGE)),
          (integer) async {
            emit(Loading());
            final failureOrTrivia =
                await getConcreteNumberTrivia(Params(number: integer));
            _eitherLoadedOrErrorState(emit, failureOrTrivia);
          },
        );
      } else if (event is GetTriviaForRandomNumber) {
        emit(Loading());
        final failureOrTrivia = await getRandomNumberTrivia(const NoParams());
        _eitherLoadedOrErrorState(emit, failureOrTrivia);
      }
    });
  }

  void _eitherLoadedOrErrorState(Emitter<NumberTriviaState> emit,
      Either<Failure, NumberTrivia> failureOrTrivia) {
    emit(
      failureOrTrivia.fold(
          (failure) => Error(errorMessage: _mapFailureToMessage(failure)),
          (trivia) => Loaded(trivia: trivia)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
