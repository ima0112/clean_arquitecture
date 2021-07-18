import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:clean_arquitecture/core/util/input_converter.dart';
import 'package:clean_arquitecture/core/error/failures.dart';
import 'package:clean_arquitecture/core/usecases/usecase.dart';

import 'package:clean_arquitecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arquitecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_arquitecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_arquitecture/features/number_trivia/domain/entities/number_trivia.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([
  GetConcreteNumberTrivia,
  GetRandomNumberTrivia,
  InputConverter,
  NumberTriviaBloc
])
void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  late NumberTriviaBloc bloc;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initialState should be Empty', () {
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test Trivia');

    const tNumberString = '1';
    const tNumberParsed = 1;

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    group('GetConcreteNumberTrivia', () {
      setUp(() {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
      });

      blocTest<NumberTriviaBloc, NumberTriviaState>(
          'should emit [Error] '
          'when the input is invalid',
          build: () => bloc,
          act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
          expect: () => [Error(message: invalidInputFailureMassage)],
          verify: (_) {
            verify(mockInputConverter.stringToUnsignedInteger(any));
          });
    });

    group('Getting data is Succesfully', () {
      setUp(() {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
      });

      test(
          'should call the InputConverter '
          'to validate and convert the string to an unsigned integer',
          () async {
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      });

      blocTest<NumberTriviaBloc, NumberTriviaState>(
          'should get data from the concrete use case',
          build: () => bloc,
          act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
          verify: (_) {
            verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
          });

      blocTest<NumberTriviaBloc, NumberTriviaState>(
          'should emit [Loading, Loaded] when data is gotten succesfully',
          build: () => bloc,
          act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
          expect: () => [Loading(), Loaded(trivia: tNumberTrivia)],
          verify: (_) {
            verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
          });
    });

    group('Getting data fails', () {
      setUp(() {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
      });

      blocTest<NumberTriviaBloc, NumberTriviaState>(
          'should emit [Loading, Error] when getting data fails',
          build: () => bloc,
          act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
          expect: () => [Loading(), Error(message: serverFailureMessage)],
          verify: (_) {
            verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
          });
    });

    group('Proper message when getting data fails', () {
      setUp(() {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
      });

      blocTest<NumberTriviaBloc, NumberTriviaState>(
          'should emit [Loading, Error] with a proper message for the error '
          'when getting data fails',
          build: () => bloc,
          act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
          expect: () => [Loading(), Error(message: cacheFailureMessage)],
          verify: (_) {
            verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
          });
    });
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test Trivia');

    group('Getting data is Succesfully', () {
      setUp(() {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
      });

      blocTest<NumberTriviaBloc, NumberTriviaState>(
          'should get data from the random use case',
          build: () => bloc,
          act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
          verify: (_) {
            verify(mockGetRandomNumberTrivia(NoParams()));
          });

      blocTest<NumberTriviaBloc, NumberTriviaState>(
          'should emit [Loading, Loaded] when data is gotten succesfully',
          build: () => bloc,
          act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
          expect: () => [Loading(), Loaded(trivia: tNumberTrivia)],
          verify: (_) {
            verify(mockGetRandomNumberTrivia(NoParams()));
          });
    });

    group('Getting data fails', () {
      setUp(() {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
      });

      blocTest<NumberTriviaBloc, NumberTriviaState>(
          'should emit [Loading, Error] when getting data fails',
          build: () => bloc,
          act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
          expect: () => [Loading(), Error(message: serverFailureMessage)],
          verify: (_) {
            verify(mockGetRandomNumberTrivia(NoParams()));
          });
    });

    group('Proper message when getting data fails', () {
      setUp(() {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
      });

      blocTest<NumberTriviaBloc, NumberTriviaState>(
          'should emit [Loading, Error] with a proper message for the error '
          'when getting data fails',
          build: () => bloc,
          act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
          expect: () => [Loading(), Error(message: cacheFailureMessage)],
          verify: (_) {
            verify(mockGetRandomNumberTrivia(NoParams()));
          });
    });
  });
}
