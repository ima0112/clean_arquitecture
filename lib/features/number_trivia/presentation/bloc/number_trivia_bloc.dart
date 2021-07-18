import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMassage =
    'Invalid Input - The number must be a positive or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  late final GetConcreteNumberTrivia getConcreteNumberTrivia;
  late final GetRandomNumberTrivia getRandomNumberTrivia;
  late final InputConverter inputConverter;

  NumberTriviaBloc(
      {required GetConcreteNumberTrivia concrete,
      required GetRandomNumberTrivia random,
      required this.inputConverter})
      : super(Empty()) {
    getConcreteNumberTrivia = concrete;
    getRandomNumberTrivia = random;
  }

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final input = inputConverter.stringToUnsignedInteger(event.numberString);

      yield* input.fold((failure) async* {
        yield Error(message: invalidInputFailureMassage);
      }, (integer) async* {
        yield Loading();
        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: integer));
        yield* _eitherLoadedOrErrorState(failureOrTrivia);
      });
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia> failureOrTrivia) async* {
    yield failureOrTrivia.fold(
        (failure) => Error(message: _mapFailureToMassage(failure)),
        (trivia) => Loaded(trivia: trivia));
  }

  String _mapFailureToMassage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected error';
    }
  }
}
