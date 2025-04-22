import 'crop.dart';

class UpdateCropResponse {
  final String message;
  final Crop crop;

  UpdateCropResponse({required this.message, required this.crop});

  factory UpdateCropResponse.fromJson(Map<String, dynamic> json) {
    return UpdateCropResponse(
      message: json['message'] as String,
      crop: Crop.fromJson(json['crop'] as Map<String, dynamic>),
    );
  }
}
