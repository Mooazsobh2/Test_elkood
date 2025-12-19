import '../../domain/entities/product.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.category,
    required super.image,
    required super.description,
    required super.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rating = json['rating'];
    final rate = rating is Map ? (rating['rate'] as num?)?.toDouble() : null;

    return ProductModel(
      id: (json['id'] as num).toInt(),
      title: (json['title'] as String?) ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      category: (json['category'] as String?) ?? '',
      image: (json['image'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      rating: rate ?? 0,
    );
  }
}
