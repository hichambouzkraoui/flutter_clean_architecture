part of 'number_trivia_bloc.dart';

sealed class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent(List<String> list);

  @override
  List<Object> get props => [];
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;
  GetTriviaForConcreteNumber(this.numberString) : super([numberString]);
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {
  GetTriviaForRandomNumber(): super([]);
}