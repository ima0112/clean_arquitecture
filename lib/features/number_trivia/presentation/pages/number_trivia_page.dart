import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

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

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [TriviaControls()],
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
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late String inputStr;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: TextFormField(
            key: Key('number trivia textFormField'),
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Input a number'),
            onChanged: (value) {
              inputStr = value;
            },
            onFieldSubmitted: (_) {
              dispatchConcrete(context);
            },
            validator: (value) =>
                value!.isEmpty ? 'Input at least one character' : null,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
              key: Key('search'),
              child: ElevatedButton(
                onPressed: () => dispatchConcrete(context),
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
                    onPressed: () => dispatchRandom(context),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.grey)),
                    child: Text('Get random trivia'))),
          ],
        )
      ],
    );
  }

  void dispatchConcrete(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _controller.clear();
      context.beamToNamed('/concrete/$inputStr');
    }
  }

  void dispatchRandom(BuildContext context) {
    _controller.clear();
    context.beamToNamed('/random');
  }
}
