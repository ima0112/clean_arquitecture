import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clean_arquitecture/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:clean_arquitecture/main.dart';
import 'package:clean_arquitecture/injection_container.dart';
import 'package:clean_arquitecture/features/number_trivia/presentation/pages/random_number_trivia_page.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await init();
  });

  group('group', () {
    testWidgets(
        'should return NumberTriviaPage '
        'like a first page', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      expect(find.byType(NumberTriviaPage), findsOneWidget);
      expect(find.byKey(Key('number trivia textFormField')), findsOneWidget);
      expect(find.byKey(Key('search')), findsOneWidget);
      expect(find.byKey(Key('random')), findsOneWidget);
    });

    testWidgets(
        'should return RandomNumberTriviaPage '
        'when the button with "random" key is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      await tester.tap(find.byKey(Key('random')));
      await tester.pumpAndSettle();

      expect(find.byType(NumberTriviaPage), findsNothing);
      expect(find.byType(RandomNumberTriviaPage), findsOneWidget);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.byType(NumberTriviaPage), findsOneWidget);
      expect(find.byType(RandomNumberTriviaPage), findsNothing);
    });
  });
}
