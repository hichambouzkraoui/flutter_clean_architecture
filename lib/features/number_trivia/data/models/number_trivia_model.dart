import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia{

  const NumberTriviaModel({ required text, required number}): super(text:text,number: number);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
     return NumberTriviaModel(
      text:json['text'], 
      number: (json['number'] as num).toInt());
  }

  Map<String, dynamic> toJson() => { 'text': text, 'number': number };
}