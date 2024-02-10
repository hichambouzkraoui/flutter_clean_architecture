import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/usecases/usecase.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_clean_architecture/features/number_trivia/usecases/get_random_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {

}

void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;
   setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
   });

   const tNumberTrivial =  NumberTrivia(text: "text", number: 1);

   test('should get trivia for the number from the repository', () async {

    // arrange
     when(() => mockNumberTriviaRepository.getRandomNumberTrivia()).thenAnswer((_) async => const  Right(tNumberTrivial));
    
    //act
    final result = await usecase(NoParams());
    
    //assert
     expect(result, const Right(tNumberTrivial));
     verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());
     verifyNoMoreInteractions(mockNumberTriviaRepository);
   });
}