
import '../../../products/domain/entities/product.dart';

class CartItemEntity {
  final ProductEntity product;
  final int qty;
  const CartItemEntity({required this.product, required this.qty});

  double get subtotal => product.price * qty;

  CartItemEntity copyWith({int? qty}) => CartItemEntity(product: product, qty: qty ?? this.qty);
}
