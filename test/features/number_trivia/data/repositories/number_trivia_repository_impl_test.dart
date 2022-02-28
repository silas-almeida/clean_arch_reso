import 'package:clean_arch_reso/core/error/exceptions.dart';
import 'package:clean_arch_reso/core/error/failures.dart';
import 'package:clean_arch_reso/core/network/network_info.dart';
import 'package:clean_arch_reso/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_arch_reso/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arch_reso/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arch_reso/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_arch_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl? repository;
  MockRemoteDataSource? mockRemoteDataSource;
  MockLocalDataSource? mockLocalDataSource;
  MockNetworkInfo? mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource!,
      localDataSource: mockLocalDataSource!,
      networkInfo: mockNetworkInfo!,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviamodel =
        NumberTriviaModel(text: 'test text', number: tNumber);
    const NumberTrivia tNumberTrivia = tNumberTriviamodel;

    test('Should check if the device is online', () async {
      when(mockNetworkInfo?.isConnected).thenAnswer((_) async => true);

      repository!.getConcreteNumberTrivia(tNumber);

      verify(mockNetworkInfo!.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is sucessful',
          () async {
        when(mockRemoteDataSource!.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviamodel);

        final result = await repository!.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));

        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should cache the data locally when the call  to remote data source is succcessful',
          () async {
        when(mockRemoteDataSource!.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviamodel);

        await repository!.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource!.cacheNumberTrivia(tNumberTriviamodel));
      });

      test(
          'Should return server failure when the call to remote data source is unsuccessful',
          () async {
        when(mockRemoteDataSource!.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());

        final result = await repository!.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'Should return last locally cached data when the cached data is present',
          () async {
        when(mockLocalDataSource!.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviamodel);

        final result = await repository!.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource!.getLastNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('Should return CacheFailure when there is no cached data present',
          () async {
        when(mockLocalDataSource!.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repository!.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource!.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    const tNumberTriviamodel = NumberTriviaModel(text: 'test text', number: 1);
    const NumberTrivia tNumberTrivia = tNumberTriviamodel;

    test('Should check if the device is online', () async {
      when(mockNetworkInfo?.isConnected).thenAnswer((_) async => true);

      repository!.getRandomNumberTrivia();

      verify(mockNetworkInfo!.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is sucessful',
          () async {
        when(mockRemoteDataSource!.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviamodel);

        final result = await repository!.getRandomNumberTrivia();

        verify(mockRemoteDataSource!.getRandomNumberTrivia());

        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should cache the data locally when the call  to remote data source is succcessful',
          () async {
        when(mockRemoteDataSource!.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviamodel);

        await repository!.getRandomNumberTrivia();

        verify(mockRemoteDataSource!.getRandomNumberTrivia());
        verify(mockLocalDataSource!.cacheNumberTrivia(tNumberTriviamodel));
      });

      test(
          'Should return server failure when the call to remote data source is unsuccessful',
          () async {
        when(mockRemoteDataSource!.getRandomNumberTrivia())
            .thenThrow(ServerException());

        final result = await repository!.getRandomNumberTrivia();

        verify(mockRemoteDataSource!.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'Should return last locally cached data when the cached data is present',
          () async {
        when(mockLocalDataSource!.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviamodel);

        final result = await repository!.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource!.getLastNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('Should return CacheFailure when there is no cached data present',
          () async {
        when(mockLocalDataSource!.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repository!.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource!.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

}
