class DiseaseModel {
  final String date;
  final String status;
  final bool isComplete;
  final String imageUrl;
  final String reason;
  final String control;
  final double confidence;

  DiseaseModel({
    required this.date,
    required this.status,
    required this.isComplete,
    required this.imageUrl,
    required this.reason,
    required this.control,
    required this.confidence,
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json) => DiseaseModel(
        date: json['date'] as String? ?? 'Unknown date',
        status: json['status'] as String? ?? 'Unknown status',
        isComplete: json['isComplete'] as bool? ?? false,
        imageUrl: json['imageUrl'] as String? ?? '',
        reason: json['reason'] as String? ?? '',
        control: json['control'] as String? ?? '',
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'status': status,
        'isComplete': isComplete,
        'imageUrl': imageUrl,
        'reason': reason,
        'control': control,
        'confidence': confidence,
      };
}
