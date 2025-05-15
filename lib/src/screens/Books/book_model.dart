class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String imageUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.imageUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      author: json['Author']?['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['cover'] ?? 'assets/images/book_placeholder.png',
    );
  }
}