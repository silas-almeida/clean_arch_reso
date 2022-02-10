import 'package:clean_arch_reso/core/usecases/usecase.dart';
import 'package:clean_arch_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch_reso/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clean_arch_reso/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia? usecase;
  MockNumberTriviaRepository? mockNumberTriviaRepository;

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(text: 'test', number: tNumber);

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository!);
  });

  test('Should get random triva from the repository', () async {
    when(mockNumberTriviaRepository!.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(tNumberTrivia));

    final result = await usecase!(const NoParams());

    expect(result, const Right(tNumberTrivia));

    verify(mockNumberTriviaRepository!.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
