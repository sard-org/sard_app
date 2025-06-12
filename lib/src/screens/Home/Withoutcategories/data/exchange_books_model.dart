class ExchangeBooksResponse {
  final List<ExchangeBook> books;

  ExchangeBooksResponse({required this.books});

  factory ExchangeBooksResponse.fromJson(Map<String, dynamic> json) {
    return ExchangeBooksResponse(
      books: (json['books'] as List<dynamic>)
          .map((book) => ExchangeBook.fromJson(book))
          .toList(),
    );
  }
}

class ExchangeBook {
  final String id;
  final String title;
  final String cover;
  final int pricePoints;
  final Author author;
  final bool isFavorite;

  ExchangeBook({
    required this.id,
    required this.title,
    required this.cover,
    required this.pricePoints,
    required this.author,
    required this.isFavorite,
  });

  factory ExchangeBook.fromJson(Map<String, dynamic> json) {
    return ExchangeBook(
      id: json['id'] as String,
      title: json['title'] as String,
      cover: json['cover'] as String,
      pricePoints:
          json['price_points'] as int? ?? json['pricePoints'] as int? ?? 0,
      author: Author.fromJson(json['Author'] ?? json['author']),
      isFavorite:
          json['is_favorite'] as bool? ?? json['isFavorite'] as bool? ?? false,
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
