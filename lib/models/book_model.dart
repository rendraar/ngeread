class Book {
  final String id; // Pastikan ada parameter id
  final String title;
  final String image;
  final String author;
  double? rating;

  Book({
    required this.id, // Ini adalah parameter yang diperlukan
    required this.title,
    required this.image,
    required this.author,
    required this.rating,
  });
}
