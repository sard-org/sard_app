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
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
    );
  }
}

class BookCategories {
  final String id;
  final String title;
  final String description;
  final String cover;
  final bool is_favorite;
  final bool isFree;
  final int? price;
  final int? pricePoints;
  final Author author;

  BookCategories({
    required this.id,
    required this.title,
    required this.description,
    required this.cover,
    required this.is_favorite,
    required this.isFree,
    this.price,
    this.pricePoints,
    required this.author,
  });

  factory BookCategories.fromJson(Map<String, dynamic> json) {
    return BookCategories(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      cover: json['cover'] ?? '',
      is_favorite: json['is_favorite'] ?? false,
      isFree: json['is_free'] ?? false,
      price: json['price'],
      pricePoints: json['price_points'],
      author: Author.fromJson(json['Author'] ?? {}),
    );
  }
}

class Author {
  final String id;
  final String name;

  Author({
    required this.id,
    required this.name,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
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

class BooksCategoriesResponse {
  final List<BookCategories> books;

  BooksCategoriesResponse({required this.books});

  factory BooksCategoriesResponse.fromJson(List<dynamic> json) {
    return BooksCategoriesResponse(
      books: json.map((item) => BookCategories.fromJson(item)).toList(),
    );
  }
}
