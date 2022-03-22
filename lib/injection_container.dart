import 'package:clean_arch_reso/core/network/network_info.dart';
import 'package:clean_arch_reso/core/utils/input_converter.dart';
import 'package:clean_arch_reso/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_arch_reso/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arch_reso/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_arch_reso/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_arch_reso/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arch_reso/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_arch_reso/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  //BLOC
  // sl.registerFactory(
  //   () => NumberTriviaBloc(
  //       getConcreteNumberTrivia: sl(),
  //       getRandomNumberTrivia: sl(),
  //       inputConverter: sl()),
  // );

  //USECASES
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  //REPOSITORY
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

  //DATA SOURCES
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
