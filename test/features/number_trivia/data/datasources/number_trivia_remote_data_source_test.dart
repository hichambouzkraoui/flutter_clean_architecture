import 'dart:convert';
import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements  http.Client {}
class FakeUri extends Fake implements Uri {}

void main() {

  setUpAll(() {
    registerFallbackValue(Uri());
  });
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

   void setUpMockHttpClientSuccess200() {
    when(() => mockHttpClient.get(any(), headers: any(named:'headers'))).thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
        when(() => mockHttpClient.get(any(), headers: any(named:'headers'))).thenAnswer(
      (_) async => http.Response('Something went wrong', 404),
    );
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    Uri url = Uri.parse('$BASE_URL/$tNumber');
    test('should preform a GET request on a URL with number being the endpoint and with application/json header', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      dataSource.getConcreteNumberTrivia(tNumber);
      //assert
        verify(() => mockHttpClient.get(url,headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response code is 200 (success)', () async {
            //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      //assert
      verify(() => mockHttpClient.get(url,headers: {'Content-Type': 'application/json'}));
      expect(result,NumberTriviaModel.fromJson(json.decode(fixture('trivia.json'))));
      
    });

    test('should throw a ServerException when the response code is 404 or other', () async {

      //arrange
      setUpMockHttpClientFailure404();
      //act
      final call = dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      await expectLater(call, throwsA(TypeMatcher<ServerException>()));

    });

  });

  group('getRandomNumberTrivia', () {
    Uri url = Uri.parse('$RANDOM_BASE_URL');
    test('should preform a GET request on a URL with number being the endpoint and with application/json header', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      dataSource.getRandomNumberTrivia();
      //assert
        verify(() => mockHttpClient.get(url,headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response code is 200 (success)', () async {
            //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await dataSource.getRandomNumberTrivia();
      //assert
      verify(() => mockHttpClient.get(url,headers: {'Content-Type': 'application/json'}));
      expect(result,NumberTriviaModel.fromJson(json.decode(fixture('trivia.json'))));
      
    });

    test('should throw a ServerException when the response code is 404 or other', () async {

      //arrange
      setUpMockHttpClientFailure404();
      //act
      final call = dataSource.getRandomNumberTrivia();
      // assert
      await expectLater(call, throwsA(TypeMatcher<ServerException>()));

    });

  });
}