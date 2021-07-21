import 'package:clean_arquitecture/main.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_arquitecture/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:clean_arquitecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockNumberTriviaBloc
    extends MockBloc<NumberTriviaEvent, NumberTriviaState>
    implements NumberTriviaBloc {}

class FakeNumberTriviaEvent extends Fake implements NumberTriviaEvent {}

class FakeNumberTriviaState extends Fake implements NumberTriviaState {}

void main() {
  // late NumberTriviaBloc numberTriviaBloc;

  setUpAll(() {
    registerFallbackValue<NumberTriviaEvent>(FakeNumberTriviaEvent());
    registerFallbackValue<NumberTriviaState>(FakeNumberTriviaState());
  });

  group('group', () {
    setUp(() {
      // numberTriviaBloc = MockNumberTriviaBloc();
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
