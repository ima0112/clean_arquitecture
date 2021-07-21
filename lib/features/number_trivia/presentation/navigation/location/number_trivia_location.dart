import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../pages/concrete_number_trivia_page.dart';
import '../../pages/number_trivia_page.dart';
import '../../pages/random_number_trivia_page.dart';

class NumberTriviaLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final beamPage = [
      BeamPage(key: ValueKey('home'), child: NumberTriviaPage()),
      if (state.uri.pathSegments.contains('random'))
        BeamPage(key: ValueKey('random'), child: RandomNumberTriviaPage()),
      if (state.pathParameters.containsKey('triviaNumber'))
        BeamPage(
            key: ValueKey('concrete-${state.pathParameters['triviaNumber']}'),
            child: ConcreteNumberTriviaPage(
                numberTrivia: state.pathParameters['triviaNumber']!)),
    ];

    return beamPage;
  }

  @override
  List get pathBlueprints => ['/home', '/random', '/concrete/:triviaNumber'];
}
