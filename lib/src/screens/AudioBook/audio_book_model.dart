class AudioBookResponse {
  final String id;
  final String cover;
  final int? pricePoints;
  final int? price; // Made nullable to handle free books
  final bool isFree;
  final String title;
  final int duration;
  final String description;
  final double rating;
  final BookAuthor author;
  final List<BookCategory> bookCategory;
  final BookCount count;
  final int? userPoints;
  AudioBookResponse({
    required this.id,
    required this.cover,
    this.pricePoints,
    this.price, // Made optional
    required this.isFree,
    required this.title,
    required this.duration,
    required this.description,
    required this.rating,
    required this.author,
    required this.bookCategory,
    required this.count,
    this.userPoints,
  });
  factory AudioBookResponse.fromJson(Map<String, dynamic> json) {
    return AudioBookResponse(
      id: json['id'] as String,
      cover: json['cover'] as String,
      pricePoints: json['price_points'] as int?,
      price: json['price'] as int?, // Made nullable
      isFree: json['is_free'] as bool,
      title: json['title'] as String,
      duration: json['duration'] as int,
      description: json['description'] as String,
      rating: (json['rating'] as num).toDouble(),
      author: BookAuthor.fromJson(json['Author']),
      bookCategory: (json['BookCategory'] as List<dynamic>)
          .map((category) => BookCategory.fromJson(category))
          .toList(),
      count: BookCount.fromJson(json['_count']),
      userPoints: json['userPoints'] as int?,
    );
  }
}

class BookAuthor {
  final String name;
  final String photo;

  BookAuthor({
    required this.name,
    required this.photo,
  });

  factory BookAuthor.fromJson(Map<String, dynamic> json) {
    return BookAuthor(
      name: json['name'] as String,
      photo: json['photo'] as String,
    );
  }
}

class BookCategory {
  final Category category;

  BookCategory({required this.category});

  factory BookCategory.fromJson(Map<String, dynamic> json) {
    return BookCategory(
      category: Category.fromJson(json['category']),
    );
  }
}

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
      id: json['id'] as String,
      name: json['name'] as String,
      photo: json['photo'] as String,
    );
  }
}

class BookCount {
  final int reviews;

  BookCount({required this.reviews});

  factory BookCount.fromJson(Map<String, dynamic> json) {
    return BookCount(
      reviews: json['reviews'] as int,
    );
  }
}
