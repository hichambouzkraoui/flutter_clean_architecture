import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/failures.dart';

class InputConverter {
  Object stringToUnsignedInteger(String str) {
    try {
      final strint = int.parse(str);
      if(strint < 0 ) throw FormatException();
      return Future.value(Right(strint));

    } on FormatException {
       return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}