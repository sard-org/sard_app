class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String imageUrl;
  final String orderId; // إضافة orderId

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.imageUrl,
    required this.orderId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      author: json['Author']?['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['cover'] ?? 'assets/images/book_placeholder.png',
      orderId: '', // سيتم تعيينه في BooksCubit
    );
  }

  // إضافة copyWith method لتحديث orderId
  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? imageUrl,
    String? orderId,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      orderId: orderId ?? this.orderId,
    );
  }
}