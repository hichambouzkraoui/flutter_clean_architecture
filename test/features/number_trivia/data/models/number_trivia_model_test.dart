import 'dart:convert';

import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';
void main() {
  const tNumberTriviaModel = NumberTriviaModel(text: 'Test Text', number: 1);

  test('should be a subclass of NumberTrivia entity', 
  () async {
    //assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  }
  );

  group('fromJson', () {

      test('should return a valid model when the JSON number is an integer', 
        () async {
          //arrange
          Map<String, dynamic> jsonMap = 
          json.decode(fixture('trivia.json'));
          //act
          final result = NumberTriviaModel.fromJson(jsonMap);
          //assert
          expect(result, tNumberTriviaModel);
        }
      );

      test('should return a valid model when the JSON number is regarded as double', 
        () async {
          //arrange
          Map<String, dynamic> jsonMap = 
          json.decode(fixture('trivia_double.json'));
          //act
          final result = NumberTriviaModel.fromJson(jsonMap);
          //assert
          expect(result, tNumberTriviaModel);
        }
      );

   });

  group('toJson', () {

      test('should return a JSON map containing proper data', 
        () async {
          //arrange
          final result = tNumberTriviaModel.toJson();
          //act
          final expected = {
            'text': 'Test Text',
            'number': 1
          };
          //assert
          expect(result, expected);
        }
      );

   });
}