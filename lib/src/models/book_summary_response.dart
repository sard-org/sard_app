class BookSummaryResponse {
  final String summary;

  BookSummaryResponse({
    required this.summary,
  });

  factory BookSummaryResponse.fromJson(Map<String, dynamic> json) {
    return BookSummaryResponse(
      summary: json['summary'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
    };
  }
}
