import 'package:clean_arch_reso/core/network/network_info.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl? networkInfo;
  MockDataConnectionChecker? mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(mockDataConnectionChecker!);
  });

  group('isConnected', () {
    test('Should forward the call to DataConnectionChecker.hasConnections',
        () async {
      final tHasConnectionFuture = Future.value(true);

      when(mockDataConnectionChecker!.hasConnection).thenAnswer((_) => tHasConnectionFuture);

      final result = networkInfo!.isConnected;

      verify(mockDataConnectionChecker!.hasConnection);
      expect(result, tHasConnectionFuture);
    });
  });
}
