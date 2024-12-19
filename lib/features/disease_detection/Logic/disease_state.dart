import 'package:equatable/equatable.dart';

abstract class DiseaseDetectionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DiseaseDetectionInitial extends DiseaseDetectionState {}

class DiseaseDetectionLoading extends DiseaseDetectionState {}

class DiseaseDetectionSuccess extends DiseaseDetectionState {
  final String diseaseClass;
  final double confidence;

  DiseaseDetectionSuccess(
      {required this.diseaseClass, required this.confidence});

  @override
  List<Object?> get props => [diseaseClass, confidence];
}

class DiseaseDetectionError extends DiseaseDetectionState {
  final String message;

  DiseaseDetectionError({required this.message});

  @override
  List<Object?> get props => [message];
}
