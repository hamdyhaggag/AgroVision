import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../Api/disease_detection_service.dart';
import 'disease_state.dart';

class DiseaseDetectionCubit extends Cubit<DiseaseDetectionState> {
  final DiseaseDetectionService _service;

  DiseaseDetectionCubit(this._service) : super(DiseaseDetectionInitial());

  Future<void> detectDisease(String filePath, String plantType) async {
    emit(DiseaseDetectionLoading());
    try {
      final result = await _service.predictDisease(filePath, plantType);
      emit(DiseaseDetectionSuccess(
        diseaseClass: result['class'],
        confidence: double.parse(result['confidence'].toString()),
      ));
    } on DioException catch (e) {
      String message = 'Network error';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = 'Connection timed out';
      } else if (e.response != null) {
        message = 'Server error (${e.response?.statusCode})';
      }
      emit(DiseaseDetectionError(message: '$message. Please try again.'));
    } on SocketException {
      emit(DiseaseDetectionError(
          message: 'No internet connection. Please check your network.'));
    } catch (e) {
      emit(DiseaseDetectionError(
        message:
            'Failed to process request: ${e.toString().replaceAll('Exception: ', '')}',
      ));
    }
  }
}
