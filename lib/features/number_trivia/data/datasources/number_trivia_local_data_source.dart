import 'dart:convert';

import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  void cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';
class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource{
  final SharedPreferences sharedPreferences;
  NumberTriviaLocalDataSourceImpl({ required this.sharedPreferences});
  @override
 Future cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    final JsonString =  json.encode(triviaToCache.toJson());
    return sharedPreferences.setString(CACHED_NUMBER_TRIVIA, JsonString);
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if(jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString!)));
    } else {
      throw CacheException();
    }
  }
  
}