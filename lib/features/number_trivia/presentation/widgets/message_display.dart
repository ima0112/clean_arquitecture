import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String message;

  const MessageDisplay({
    required this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Text(
          message,
          style: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
