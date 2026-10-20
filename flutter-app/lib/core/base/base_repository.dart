import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'exceptions.dart';
import 'failure.dart';

abstract base class BaseRepository {
  Future<Either<DataCRUDFailure, T>> asyncTryCatch<T>({required Future<T> Function() tryFunc, }) async{
      try {
        return await tryFunc().then((value) => Right(value));
        
      } on ServerException catch(e){
        return Left(DataCRUDFailure(failure: Failure.severFailure, fullError: 'Server failed!'));
      } on NoDataException catch(e){
        return Left(DataCRUDFailure(failure: Failure.noData, fullError: "Doesn't exist!"));
      } on SocketException {
        return Left(DataCRUDFailure(failure: Failure.socketFailure, fullError: 'Internet connection failed!'));
      } on DioException catch (e){
        debugPrint(".. \n..\n");
        debugPrint(e.response?.data["message"].toString());
        debugPrint(".. \n..\n");
        //debugger?.dekhao("DioFailure $e");
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            return Left(DataCRUDFailure(failure: Failure.timeout, fullError: 'Connection timeout! Make sure internet is connected!'));
          case DioExceptionType.receiveTimeout:
            return Left(DataCRUDFailure(failure: Failure.timeout, fullError: 'Connection timeout! Make sure internet is connected!'));
          case DioExceptionType.sendTimeout:
            return Left(DataCRUDFailure(failure: Failure.timeout, fullError: 'Connection timeout! Make sure internet is connected!'));
          case DioExceptionType.cancel:
            return Left(DataCRUDFailure(failure: Failure.unknownFailure, uiMessage: "Request cancelled!", fullError: 'Some error occured. ${'\n'} Error: ${e.toString()}'));
          default:
            return Left(DataCRUDFailure(failure: Failure.unknownFailure, uiMessage: e.response?.data["message"] ?? "Some error occured.", fullError: 'Some error occured. ${'\n'} Error: ${e.toString()}',));
        }
      } catch (e) {
        debugPrint(e.toString());
        //debugger?.dekhao(e);
        return Left(DataCRUDFailure(failure: Failure.unknownFailure, uiMessage: 'Some error occured.', fullError: "Some error occured. ${'\n'} Error: ${e.toString()}"));
      }
  }

  Either<DataCRUDFailure, T> tryCatch<T>({required T Function() tryFunc, }) {
      try {
        return Right(tryFunc());
        
      } on ServerException {
        return Left(DataCRUDFailure(failure: Failure.severFailure, fullError: ''));
      } on SocketException {
        return Left(DataCRUDFailure(failure: Failure.socketFailure, fullError: 'Internet connection failed!'));
      } catch (e) {
        return Left(DataCRUDFailure(failure: Failure.unknownFailure, fullError: 'Some error occured. Error: ${e.toString()}'));
      }
  }
}



