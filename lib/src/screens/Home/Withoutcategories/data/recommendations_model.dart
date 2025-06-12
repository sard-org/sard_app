class RecommendationsResponse {
  final List<RecommendedBook> books;

  RecommendationsResponse({required this.books});

  factory RecommendationsResponse.fromJson(Map<String, dynamic> json) {
    return RecommendationsResponse(
      books: (json['books'] as List<dynamic>)
          .map((book) => RecommendedBook.fromJson(book))
          .toList(),
    );
  }
}

class RecommendedBook {
  final String id;
  final String title;
  final String description;
  final int price;
  final String cover;
  final Author author;
  final bool isFavorite;

  RecommendedBook({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.cover,
    required this.author,
    required this.isFavorite,
  });

  factory RecommendedBook.fromJson(Map<String, dynamic> json) {
    return RecommendedBook(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      cover: json['cover'] as String,
      author: Author.fromJson(json['Author']),
      isFavorite: json['is_favorite'] as bool,
    );
  }
}

class Author {
  final String name;

  Author({required this.name});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      name: json['name'] as String,
    );
  }
}
