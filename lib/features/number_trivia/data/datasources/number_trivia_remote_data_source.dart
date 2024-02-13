import 'dart:convert';

import 'package:flutter_clean_architecture/core/error/exceptions.dart';

import '../models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

const BASE_URL ='http://numbersapi.com';
const RANDOM_BASE_URL = 'http://numbersapi.com/random';
class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;
NumberTriviaRemoteDataSourceImpl({ required this.client});
  
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {

    http.Response response = await client.get(Uri.parse('$BASE_URL/$number'),headers: {'Content-Type': 'application/json'});
    if(response.statusCode == 200 ) {
    return  Future.value(NumberTriviaModel.fromJson(json.decode(response.body)));
    }
    throw ServerException();
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    http.Response response = await client.get(Uri.parse(RANDOM_BASE_URL),headers: {'Content-Type': 'application/json'});
    if(response.statusCode == 200 ) {
    return  Future.value(NumberTriviaModel.fromJson(json.decode(response.body)));
    }
    throw ServerException();
  }
}