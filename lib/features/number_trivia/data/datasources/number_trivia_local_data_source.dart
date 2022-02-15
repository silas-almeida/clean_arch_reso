import 'package:clean_arch_reso/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  ///Get the cached [NumberTriviaModel] wich was gotten the last time
  ///the user had an internet connection.
  ///
  ///Throws [CacheException] if no cached data is present;
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}
