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
      id: json['id']?.toString() ?? '',
      cover: json['cover']?.toString() ?? '',
      pricePoints: json['price_points'] as int?,
      price: json['price'] as int?,
      isFree: json['is_free'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      duration: json['duration']?.toInt() ?? 0,
      description: json['description']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      author: json['Author'] != null 
          ? BookAuthor.fromJson(json['Author'])
          : BookAuthor(name: '', photo: ''),
      bookCategory: json['BookCategory'] != null 
          ? (json['BookCategory'] as List<dynamic>)
              .map((category) => BookCategory.fromJson(category))
              .toList()
          : [],
      count: json['_count'] != null 
          ? BookCount.fromJson(json['_count'])
          : BookCount(reviews: 0),
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
      name: json['name']?.toString() ?? '',
      photo: json['photo']?.toString() ?? '',
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
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      photo: json['photo']?.toString() ?? '',
    );
  }
}

class BookCount {
  final int reviews;

  BookCount({required this.reviews});

  factory BookCount.fromJson(Map<String, dynamic> json) {
    return BookCount(
      reviews: json['reviews']?.toInt() ?? 0,
    );
  }
}

class OrderResponse {
  final String orderId;
  final OrderData order;
  final String? paymentUrl;

  OrderResponse({
    required this.orderId,
    required this.order,
    this.paymentUrl,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    final orderData = OrderData.fromJson(json['order']);
    return OrderResponse(
      orderId: orderData.id,
      order: orderData,
      paymentUrl: json['paymentUrl'],
    );
  }
}

class OrderData {
  final String id;
  final OrderBook book;
  final OrderUser user;

  OrderData({
    required this.id,
    required this.book,
    required this.user,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id']?.toString() ?? '',
      book: OrderBook.fromJson(json['book']),
      user: OrderUser.fromJson(json['user']),
    );
  }
}

class OrderBook {
  final String id;
  final String title;
  final String description;
  final String cover;
  final int duration;
  final OrderAuthor author;

  OrderBook({
    required this.id,
    required this.title,
    required this.description,
    required this.cover,
    required this.duration,
    required this.author,
  });

  factory OrderBook.fromJson(Map<String, dynamic> json) {
    return OrderBook(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      cover: json['cover']?.toString() ?? '',
      duration: json['duration']?.toInt() ?? 0,
      author: json['Author'] != null 
          ? OrderAuthor.fromJson(json['Author'])
          : OrderAuthor(name: ''),
    );
  }
}

class OrderAuthor {
  final String name;

  OrderAuthor({required this.name});

  factory OrderAuthor.fromJson(Map<String, dynamic> json) {
    return OrderAuthor(name: json['name']?.toString() ?? '');
  }
}

class OrderUser {
  final String id;
  final String email;
  final String name;
  final String phone;

  OrderUser({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
  });

  factory OrderUser.fromJson(Map<String, dynamic> json) {
    return OrderUser(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
    );
  }
}

// New model for audio book content response
class AudioBookContentResponse {
  final String id;
  final String title;
  final String description;
  final String cover;
  final int duration;
  final String audioUrl;
  final OrderAuthor author;
  final List<BookCategory> bookCategory;
  final double rating;
  final BookCount count;

  AudioBookContentResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.cover,
    required this.duration,
    required this.audioUrl,
    required this.author,
    required this.bookCategory,
    required this.rating,
    required this.count,
  });

  factory AudioBookContentResponse.fromJson(Map<String, dynamic> json) {
    final book = json['book'] ?? json; // Handle if book is nested or direct
    
    return AudioBookContentResponse(
      id: book['id']?.toString() ?? '',
      title: book['title']?.toString() ?? '',
      description: book['description']?.toString() ?? '',
      cover: book['cover']?.toString() ?? '',
      duration: book['duration']?.toInt() ?? 0,
      audioUrl: book['audio']?.toString() ?? '',
      author: book['Author'] != null 
          ? OrderAuthor.fromJson(book['Author'])
          : OrderAuthor(name: ''),
      bookCategory: book['BookCategory'] != null 
          ? (book['BookCategory'] as List<dynamic>)
              .map((category) => BookCategory.fromJson(category))
              .toList()
          : [],
      rating: (book['rating'] as num?)?.toDouble() ?? 0.0,
      count: book['_count'] != null 
          ? BookCount.fromJson(book['_count'])
          : BookCount(reviews: 0),
    );
  }

  // Create a single audio segment from the audio URL
  List<AudioSegment> get audioSegments {
    if (audioUrl.isNotEmpty) {
      return [
        AudioSegment(
          text: description.isNotEmpty ? description : title,
          url: audioUrl,
          order: 0,
        )
      ];
    }
    return [];
  }
}

class AudioSegment {
  final String text;
  final String url;
  final int order;

  AudioSegment({
    required this.text,
    required this.url,
    required this.order,
  });

  factory AudioSegment.fromJson(Map<String, dynamic> json) {
    return AudioSegment(
      text: json['text']?.toString() ?? json['shortText']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      order: json['order']?.toInt() ?? 0,
    );
  }
}
