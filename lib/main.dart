import 'dart:math';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'features/number_trivia/presentation/navigation/route.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final routerDelegate = sl<Routes>().routerDelegate;

  @override
  Widget build(BuildContext context) {
    print('Hello World!');
    return BlocProvider(
      create: (context) => sl<NumberTriviaBloc>(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Number Trivia',
        theme: ThemeData(
            primaryColor: Colors.green.shade800,
            accentColor: Colors.green.shade600),
        routerDelegate: routerDelegate,
        routeInformationParser: BeamerParser(),
        backButtonDispatcher: BeamerBackButtonDispatcher(
            delegate: routerDelegate as BeamerDelegate<BeamState>),
      ),
    );
  }
}
