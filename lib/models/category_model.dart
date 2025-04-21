class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class CategoryResponse {
  final List<Category> categories;

  CategoryResponse({required this.categories});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    var categories = json['data'] as List;
    return CategoryResponse(
      categories: categories.map((e) => Category.fromJson(e)).toList(),
    );
  }
}
