import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter_clean_architecture/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {

  late MockDataConnectionChecker mockDataConnectionChecker;
  late NetworkInfoImpl networkInfoImpl;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
      test('should forward the call to DataConnectionChecker.hasConnection', () async {
        //arrange
        final tHasConnectionFuture = Future.value(true);
        when(() => mockDataConnectionChecker.hasConnection).thenAnswer((_)  => tHasConnectionFuture);
        //act
        final isConnected =  networkInfoImpl.isConnected;
        //assert
        verify(() => mockDataConnectionChecker.hasConnection);
        expect(isConnected, tHasConnectionFuture);
    
  });
   });

}