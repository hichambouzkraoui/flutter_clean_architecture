import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/core/usecases/usecase.dart';
import 'package:flutter_clean_architecture/core/util/input_converter.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia concrete;
  final GetRandomNumberTrivia random;
  final InputConverter inputConverter;
  NumberTriviaBloc({
    required this.concrete,
    required this.random,
    required this.inputConverter
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>((event, emit) async {
        final Either<Failure, int> converted = inputConverter.stringToUnsignedInteger(event.numberString);
        converted.fold(
          (failure) => emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE)), 
          (integer) async {
            emit(Loading());
            Either<Failure, NumberTrivia> failureOrTrivia = await concrete(Params(number: integer));
            _eitherLoadedOrErrorState(failureOrTrivia);
          }
        );
    });

    on<GetTriviaForRandomNumber>((event, emit) async {
      emit(Loading());
      Either<Failure, NumberTrivia> failureOrTrivia = await random(NoParams());
      _eitherLoadedOrErrorState(failureOrTrivia);
    });

  }

  void _eitherLoadedOrErrorState(Either<Failure, NumberTrivia> either) {
      either.fold(
        (failure) => emit(Error(message: _errorToMsg(failure))),
        (trivia) => emit(Loaded(trivia: trivia))
      );
  }

  String _errorToMsg(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
