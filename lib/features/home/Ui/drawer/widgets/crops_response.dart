import 'crop.dart';

class CropsResponse {
  final List<Crop> crops;

  CropsResponse({required this.crops});

  factory CropsResponse.fromJson(Map<String, dynamic> json) {
    var cropsList = json['Crops'] as List;
    List<Crop> crops = cropsList.map((e) => Crop.fromJson(e)).toList();
    return CropsResponse(crops: crops);
  }
}
