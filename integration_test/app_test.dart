import 'package:clean_arquitecture/core/util/input_converter.dart';
import 'package:clean_arquitecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arquitecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_arquitecture/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_arquitecture/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:clean_arquitecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import 'number_trivia_bloc_test.mocks.dart';

class MockNumberTriviaBloc
    extends MockBloc<NumberTriviaEvent, NumberTriviaState>
    implements NumberTriviaBloc {}

class FakeNumberTriviaEvent extends Fake implements NumberTriviaEvent {}

class FakeNumberTriviaState extends Fake implements NumberTriviaState {}

void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  late NumberTriviaBloc numberTriviaBloc;

  setUpAll(() {
    registerFallbackValue<NumberTriviaEvent>(FakeNumberTriviaEvent());
    registerFallbackValue<NumberTriviaState>(FakeNumberTriviaState());
  });

  group('group', () {
    setUp(() {
      // mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
      // mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
      // mockInputConverter = MockInputConverter();

      // numberTriviaBloc = NumberTriviaBloc(
      //     concrete: mockGetConcreteNumberTrivia,
      //     random: mockGetRandomNumberTrivia,
      //     inputConverter: mockInputConverter);

      numberTriviaBloc = MockNumberTriviaBloc();
    });

    testWidgets('test', (WidgetTester tester) async {
      // when(() => numberTriviaBloc.state).thenReturn(Empty());

      await tester.pumpWidget(MyApp());

      // await tester.tap(find.byKey(Key('search')));
      // await tester.pumpAndSettle();

      expect(find.byType(NumberTriviaPage), findsOneWidget);
      // expect(find.text('1'), findsOneWidget);
    });
  });
}
