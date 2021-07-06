import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:clean_arquitecture/core/network/network_info.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
void main() {
  late NetworkInfoImpl networkInfo;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group('isConnected', () {
    test(
        'should forward the call to '
        'InternetConnectionCheker.hasConnection', () async {
      when(mockInternetConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);

      final result = await networkInfo.isConnected;

      verify(mockInternetConnectionChecker.hasConnection);
      expect(result, true);
    });
  });
}
