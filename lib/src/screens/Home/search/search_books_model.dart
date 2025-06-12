class SearchBooksResponse {
  final List<SearchBook> books;

  SearchBooksResponse({required this.books});

  factory SearchBooksResponse.fromJson(Map<String, dynamic> json) {
    return SearchBooksResponse(
      books: (json['books'] as List<dynamic>)
          .map((book) => SearchBook.fromJson(book))
          .toList(),
    );
  }
}

class SearchBook {
  final String id;
  final String title;
  final String description;
  final int? price; // Made nullable
  final int? pricePoints;
  final bool isFree;
  final String cover;
  final Author author;
  final bool isFavorite;

  SearchBook({
    required this.id,
    required this.title,
    required this.description,
    this.price, // Made optional
    this.pricePoints,
    required this.isFree,
    required this.cover,
    required this.author,
    required this.isFavorite,
  });

  factory SearchBook.fromJson(Map<String, dynamic> json) {
    return SearchBook(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as int?, // Safe nullable casting
      pricePoints: json['price_points'] as int?,
      isFree: json['is_free'] as bool? ?? false, // Default to false if missing
      cover: json['cover'] as String,
      author: Author.fromJson(json['Author']),
      isFavorite:
          json['is_favorite'] as bool? ?? false, // Default to false if missing
    );
  }

  // Helper methods to get pricing information
  String get priceDisplay {
    if (isFree) return 'Free';
    if (pricePoints != null) return '$pricePoints Points';
    if (price != null) return '\$$price';
    return 'Price not available';
  }

  bool get hasValidPrice => isFree || price != null || pricePoints != null;
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
