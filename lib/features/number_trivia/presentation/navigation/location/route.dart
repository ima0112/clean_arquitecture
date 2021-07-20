import 'package:beamer/beamer.dart';
import 'package:clean_arquitecture/features/number_trivia/presentation/navigation/location/number_trivia_location.dart';
import 'package:clean_arquitecture/features/number_trivia/presentation/navigation/route.dart';
import 'package:flutter/material.dart';

class BeamerRoutesImpl implements Routes {
  @override
  RouterDelegate<Object> get routerDelegate => BeamerDelegate(
        locationBuilder: (state) => NumberTriviaLocation(state),
      );
}
