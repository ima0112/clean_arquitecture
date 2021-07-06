import 'package:clean_arquitecture/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
        'should return an integer '
        'when the string represent an unsigned integer', () async {
      const str = '123';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Right(123));
    });

    test(
        'should return a Failure '
        'when the string is not an integer', () async {
      const str = 'abc';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });

    test(
        'should return a Failure '
        'when the string is a negative integer', () async {
      const str = '-123';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });
  });
}
