class Crop {
  final int id;
  final int userId;
  final String productName;
  final String productCategory;
  final String pricePerKilo;
  final int quantity;
  final String status;
  final String? photo;
  final DateTime? deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Crop({
    required this.id,
    required this.userId,
    required this.productName,
    required this.productCategory,
    required this.pricePerKilo,
    required this.quantity,
    required this.status,
    this.photo,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      productName: json['productName'] as String? ?? '',
      productCategory: json['productCategory'] as String? ?? '',
      pricePerKilo: json['pricePerKilo'] as String? ?? '0.00',
      quantity: json['quantity'] as int? ?? 0,
      status: json['status'] as String? ?? 'Unknown',
      photo: json['photo'] as String?,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }
}
