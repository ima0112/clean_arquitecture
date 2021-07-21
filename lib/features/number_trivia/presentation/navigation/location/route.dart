import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../route.dart';
import 'number_trivia_location.dart';

class BeamerRoutesImpl implements Routes {
  @override
  RouterDelegate<Object> get routerDelegate => BeamerDelegate(
        locationBuilder:
            BeamerLocationBuilder(beamLocations: [NumberTriviaLocation()]),
      );
}
