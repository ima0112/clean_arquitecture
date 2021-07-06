import 'package:dartz/dartz.dart';

import 'package:clean_arquitecture/core/error/exceptions.dart';
import 'package:clean_arquitecture/core/error/failures.dart';
import 'package:clean_arquitecture/core/network/network_info.dart';

import 'package:clean_arquitecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arquitecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_arquitecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arquitecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arquitecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef _ConcreteOpRandomChooser = Future<NumberTriviaModel> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocaDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return _getTrivia(() => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcreteOpRandomChooser getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);

        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
