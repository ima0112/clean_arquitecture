import 'dart:io';

import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable {
  final String text;
  final int number;

  NumberTrivia({required this.number, required this.text});

  @override
  List<Object?> get props => [text, number];

  String fixture(String name) =>
      File('features/number_trivia/domain/entities/$name').readAsStringSync();
}
