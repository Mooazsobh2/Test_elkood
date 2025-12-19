import 'package:get/get.dart';
import '../../../app/services/local_storage_service.dart';
import '../../products/domain/entities/product.dart';
import '../domain/entities/cart_item.dart';

class CartController extends GetxController {
  final LocalStorageService storage;
  CartController(this.storage);

  final items = <CartItemEntity>[].obs;

  double get total => items.fold(0, (s, x) => s + x.subtotal);
  int get count => items.fold(0, (s, x) => s + x.qty);

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  void _load() {
    final raw = storage.cart;
    final loaded = raw.map((m) {
      final p = ProductEntity(
        id: (m['product']['id'] as num).toInt(),
        title: (m['product']['title'] as String?) ?? '',
        price: (m['product']['price'] as num?)?.toDouble() ?? 0,
        category: (m['product']['category'] as String?) ?? '',
        image: (m['product']['image'] as String?) ?? '',
        description: (m['product']['description'] as String?) ?? '',
        rating: ((m['product']['rating'] as Map?)?['rate'] as num?)?.toDouble() ?? 0,
      );
      return CartItemEntity(product: p, qty: (m['qty'] as num?)?.toInt() ?? 1);
    }).toList();
    items.assignAll(loaded);
  }

  Future<void> _persist() async {
    final raw = items.map((x) {
      return {
        'qty': x.qty,
        'product': {
          'id': x.product.id,
          'title': x.product.title,
          'price': x.product.price,
          'category': x.product.category,
          'image': x.product.image,
          'description': x.product.description,
          'rating': {'rate': x.product.rating},
        }
      };
    }).toList();
    await storage.setCart(raw);
  }

  Future<void> add(ProductEntity p) async {
    final idx = items.indexWhere((x) => x.product.id == p.id);
    if (idx == -1) {
      items.add(CartItemEntity(product: p, qty: 1));
    } else {
      items[idx] = items[idx].copyWith(qty: (items[idx].qty + 1).clamp(1, 99));
    }
    await _persist();
  }

  Future<void> inc(int id) async {
    final idx = items.indexWhere((x) => x.product.id == id);
    if (idx == -1) return;
    items[idx] = items[idx].copyWith(qty: (items[idx].qty + 1).clamp(1, 99));
    await _persist();
  }

  Future<void> dec(int id) async {
    final idx = items.indexWhere((x) => x.product.id == id);
    if (idx == -1) return;
    items[idx] = items[idx].copyWith(qty: (items[idx].qty - 1).clamp(1, 99));
    await _persist();
  }

  Future<void> remove(int id) async {
    items.removeWhere((x) => x.product.id == id);
    await _persist();
  }

  Future<void> clear() async {
    items.clear();
    await _persist();
  }
}
