class Crop {
  final int id;
  final int userId;
  final String productName;
  final String productCategory;
  final String pricePerKilo;
  final int quantity;
  final String status;
  final String? photo;
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
    this.createdAt,
    this.updatedAt,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      productName: json['productName'] as String,
      productCategory: json['productCategory'] as String,
      pricePerKilo: json['pricePerKilo'] as String,
      quantity: json['quantity'] as int,
      status: json['status'] as String,
      photo: json['photo'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}
