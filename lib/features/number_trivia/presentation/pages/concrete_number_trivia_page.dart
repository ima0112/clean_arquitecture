import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class ConcreteNumberTriviaPage extends StatefulWidget {
  const ConcreteNumberTriviaPage({
    required this.numberTrivia,
    Key? key,
  }) : super(key: key);

  final String numberTrivia;

  @override
  _ConcreteNumberTriviaPageState createState() =>
      _ConcreteNumberTriviaPageState();
}

class _ConcreteNumberTriviaPageState extends State<ConcreteNumberTriviaPage> {
  @override
  void initState() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(widget.numberTrivia));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Concrete Number Trivia'),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: size.height * 0.4,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
            builder: (context, state) {
              if (state is Empty) {
                return MessageDisplay(
                  message: 'Start',
                );
              } else if (state is Loading) {
                return LoadingWidget();
              } else if (state is Loaded) {
                return TriviaDisplay(numberTrivia: state.trivia);
              } else if (state is Error) {
                return MessageDisplay(message: state.message);
              }
              return Placeholder();
            },
          ),
        ),
      ),
    );
  }
}
