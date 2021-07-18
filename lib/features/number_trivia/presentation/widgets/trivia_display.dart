import 'package:flutter/material.dart';

import '../../domain/entities/number_trivia.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia numberTrivia;

  const TriviaDisplay({
    required this.numberTrivia,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          numberTrivia.number.toString(),
          style: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 8.0,
        ),
        Expanded(
          child: Center(
              child: CustomScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                Text(
                  numberTrivia.text,
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ]))
            ],
          )),
        ),
      ],
    );
  }
}
