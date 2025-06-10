class Category {
  final String id;
  final String name;
  final String photo;

  Category({
    required this.id,
    required this.name,
    required this.photo,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
    );
  }
}

class CategoryResponse {
  final List<Category> categories;

  CategoryResponse({required this.categories});

  factory CategoryResponse.fromJson(List<dynamic> json) {
    return CategoryResponse(
      categories: json.map((item) => Category.fromJson(item)).toList(),
    );
  }
}
