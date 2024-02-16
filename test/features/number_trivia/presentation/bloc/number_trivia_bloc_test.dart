import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/core/util/input_converter.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_clean_architecture/features/number_trivia/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/usecases/get_random_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
   setUpAll(() {
    registerFallbackValue(Params(number:1));
  });

    setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
  // assert
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', (){
    // The event takes in a String
    final tNumberString = '1';
    // This is the successful output of the InputConverter
    final tNumberParsed = int.parse(tNumberString);
    // NumberTrivia instance is needed too, of course
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');
    void mockDependencies (Either<Failure, int> res1,Either<Failure, NumberTrivia> res2) {
      when(() => mockInputConverter.stringToUnsignedInteger(any()))
      .thenReturn(res1);
      when(() => mockGetConcreteNumberTrivia(any()))
      .thenAnswer((_) async => res2);
    }
    test('should call the InputConverter to validate and convert the string to an unsigned integer', () async {
      //arrange
      mockDependencies(Right(tNumberParsed),Right(tNumberTrivia));
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(() => mockInputConverter.stringToUnsignedInteger(any()));
      //assert
      verify(() => mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test( 'should emit [Error] when the input is invalid', () async {
      // arrange
      mockDependencies(Left(InvalidInputFailure()),Right(tNumberTrivia));
      //assert later
      final expected = [Error(message: INVALID_INPUT_FAILURE_MESSAGE)];
      expectLater(bloc.stream, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should get data from the concrete use case', () async {
      //arrange
      mockDependencies(Right(tNumberParsed),Right(tNumberTrivia));
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(() => mockGetConcreteNumberTrivia(any()));
      //assert
      verify(() => mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });
    test('should emit [Loading, Loaded] when data is gotten successfully', () async {
      //arrange
      mockDependencies(Right(tNumberParsed),Right(tNumberTrivia));
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      // assert later
      final expected = [
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      
    });

    test('should emit [Loading, Error] when getting data fails',() async {
      //arrange
      mockDependencies(Right(tNumberParsed),Left(ServerFailure()));
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      //assert
        final expected = [
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

  });

  test('should emit [Loading, Error] with a proper message for the error when getting data fails',() async {
    //arrange
    mockDependencies(Right(tNumberParsed),Left(CacheFailure()));
    //act
    bloc.add(GetTriviaForConcreteNumber(tNumberString));
    //assert
      final expected = [
      Loading(),
      Error(message: CACHE_FAILURE_MESSAGE),
    ];
    expectLater(bloc.stream, emitsInOrder(expected));
  });
});

}