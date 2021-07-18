import 'package:bloc_test/bloc_test.dart';
import 'package:clean_arquitecture/core/util/input_converter.dart';
import 'package:clean_arquitecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arquitecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_arquitecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_arquitecture/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:clean_arquitecture/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:mockito/annotations.dart';

class MockNumberTriviaBloc
    extends MockBloc<NumberTriviaEvent, NumberTriviaState>
    implements NumberTriviaBloc {}

void main() {
  late NumberTriviaBloc numberTriviaBloc;

  setUp(() {
    numberTriviaBloc = MockNumberTriviaBloc();
  });

  testWidgets('test', (WidgetTester tester) async {
    await tester.pumpWidget(BlocProvider.value(
      value: numberTriviaBloc,
      child: MyApp(),
    ));

    await tester.tap(find.byKey(Key('search')));
    await tester.pumpAndSettle();

    expect(find.byType(NumberTriviaPage), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });
}
