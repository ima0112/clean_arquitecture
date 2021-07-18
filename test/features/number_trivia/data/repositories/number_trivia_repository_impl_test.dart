import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_arquitecture/core/error/failures.dart';
import 'package:clean_arquitecture/core/error/exceptions.dart';
import 'package:clean_arquitecture/core/network/network_info.dart';

import 'package:clean_arquitecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arquitecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arquitecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_arquitecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arquitecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks(
    [NumberTriviaRemoteDataSource, NumberTriviaLocalDataSource, NetworkInfo])
void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockNumberTriviaLocaDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNumberTriviaLocaDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockNumberTriviaRemoteDataSource,
      localDataSource: mockNumberTriviaLocaDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'Test Trivia', number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    runTestOnline(() {
      test(
          'should return remote data when '
          'the call to remote data source is successful', () async {
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verify(mockNetworkInfo.isConnected);
        verify(
            mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, Right(tNumberTrivia));
      });

      test(
          'should cache the data locally when '
          'the call to remote data source is successful', () async {
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        await repository.getConcreteNumberTrivia(tNumber);

        verify(mockNetworkInfo.isConnected);
        verify(
            mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockNumberTriviaLocaDataSource
            .cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return ServerFailure when '
          'the call to remote data source is unsuccessful', () async {
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verify(mockNetworkInfo.isConnected);
        verify(
            mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockNumberTriviaLocaDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
          'should return last locally cached data '
          'when tha cached data is present', () async {
        when(mockNumberTriviaLocaDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verify(mockNetworkInfo.isConnected);
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocaDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });

      test(
          'should return CacheFailure cached data '
          'when there is no cached data present', () async {
        when(mockNumberTriviaLocaDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verify(mockNetworkInfo.isConnected);
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocaDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'Test Trivia', number: 123);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    runTestOnline(() {
      test(
          'should return remote data when '
          'the call to remote data source is successful', () async {
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getRandomNumberTrivia();

        verify(mockNetworkInfo.isConnected);
        verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });

      test(
          'should cache the data locally when '
          'the call to remote data source is successful', () async {
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        await repository.getRandomNumberTrivia();

        verify(mockNetworkInfo.isConnected);
        verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
        verify(mockNumberTriviaLocaDataSource
            .cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return ServerFailure when '
          'the call to remote data source is unsuccessful', () async {
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        final result = await repository.getRandomNumberTrivia();

        verify(mockNetworkInfo.isConnected);
        verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockNumberTriviaLocaDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
          'should return last locally cached data '
          'when tha cached data is present', () async {
        when(mockNumberTriviaLocaDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getRandomNumberTrivia();

        verify(mockNetworkInfo.isConnected);
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocaDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });

      test(
          'should return CacheFailure cached data '
          'when there is no cached data present', () async {
        when(mockNumberTriviaLocaDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repository.getRandomNumberTrivia();

        verify(mockNetworkInfo.isConnected);
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocaDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
