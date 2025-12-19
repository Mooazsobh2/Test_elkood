class ProductEntity {
  final int id;
  final String title;
  final double price;
  final String category;
  final String image;
  final String description;
  final double rating;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.image,
    required this.description,
    required this.rating,
  });
}
