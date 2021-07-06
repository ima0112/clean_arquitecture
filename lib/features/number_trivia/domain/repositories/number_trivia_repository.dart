import 'package:dartz/dartz.dart';

import 'package:clean_arquitecture/core/error/failures.dart';
import 'package:clean_arquitecture/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
