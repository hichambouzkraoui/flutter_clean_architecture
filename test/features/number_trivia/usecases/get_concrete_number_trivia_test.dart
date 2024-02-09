import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_clean_architecture/features/number_trivia/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {

}

void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;
   setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
   });

   final tNumber = 1;
   final tNumberTrivial = NumberTrivia(text: "text", number: 1);

   test('should get trivia for the number from the repository', () async {

    // arrange
     when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(any())).thenAnswer((_) async =>  Right(tNumberTrivial));
    
    //act
    final result = await usecase(Params(number: tNumber));
    
    //assert
     expect(result, Right(tNumberTrivial));
     verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
     verifyNoMoreInteractions(mockNumberTriviaRepository);
   });
}