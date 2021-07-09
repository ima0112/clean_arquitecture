import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:clean_arquitecture/core/util/input_converter.dart';
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

    test(
        'should call the InputConverter '
        'to validate and convert the string to an unsigned integer', () async {
      when(mockInputConverter.stringToUnsignedInteger(tNumberString))
          .thenReturn(Right(tNumberParsed));

      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    group(
        'should emit [Error] '
        'when the input is invalid', () {
      setUp(() {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
      });

      blocTest<NumberTriviaBloc, NumberTriviaState>(
          'emits [MyState] when MyEvent is added.',
          build: () => bloc,
          act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
          expect: () => [Error(message: invalidInputFailureMassage)],
          verify: (_) {
            verify(mockInputConverter.stringToUnsignedInteger(any));
          });
    });
  });
}
