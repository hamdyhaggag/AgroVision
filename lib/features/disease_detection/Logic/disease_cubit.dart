import 'package:bloc/bloc.dart';
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
    } catch (e) {
      emit(DiseaseDetectionError(message: e.toString()));
    }
  }
}
