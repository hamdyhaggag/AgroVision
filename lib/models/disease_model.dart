class DiseaseModel {
  final String date;
  final String status;
  final bool isComplete;
  final String imageUrl;

  DiseaseModel({
    required this.date,
    required this.status,
    required this.isComplete,
    required this.imageUrl,
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      isComplete: json['isComplete'] ?? false,
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
