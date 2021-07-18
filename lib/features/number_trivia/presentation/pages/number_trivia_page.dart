import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NumberTriviaBloc>(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            topHalf(context),
            SizedBox(
              height: 16.0,
            ),
            TriviaControls()
          ],
        ),
      ),
    );
  }

  Widget topHalf(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.4,
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
    );
  }
}

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key? key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  late String inputStr;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.2,
      child: Column(
        children: [
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Input a number'),
            onChanged: (value) {
              inputStr = value;
            },
            onSubmitted: (_) {
              dispatchConcrete();
            },
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                key: Key('search'),
                child: ElevatedButton(
                  onPressed: dispatchConcrete,
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).accentColor)),
                  child: Text('Search'),
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Expanded(
                  key: Key('random'),
                  child: ElevatedButton(
                      onPressed: dispatchRandom,
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.grey)),
                      child: Text('Get random trivia'))),
            ],
          )
        ],
      ),
    );
  }

  void dispatchConcrete() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputStr));
  }

  void dispatchRandom() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
