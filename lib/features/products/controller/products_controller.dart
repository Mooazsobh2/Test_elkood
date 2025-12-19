import 'package:get/get.dart';
import '../../../app/services/api_service.dart';
import '../domain/entities/product.dart';
import '../data/models/product_model.dart';

enum ProductsStatus { idle, loading, ready, error }

class ProductsController extends GetxController {
  final ApiService api;
  ProductsController(this.api);

  final status = ProductsStatus.idle.obs;
  final items = <ProductEntity>[].obs;
  final filtered = <ProductEntity>[].obs;
  final query = ''.obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetch();
    ever(query, (_) => _applyFilter());
  }

  Future<void> fetch() async {
    status.value = ProductsStatus.loading;
    error.value = null;
    try {
      final res = await api.dio.get('/products');
      final list = (res.data as List).cast<Map<String, dynamic>>();
      final data = list.map(ProductModel.fromJson).toList();
      items.assignAll(data);
      _applyFilter();
      status.value = ProductsStatus.ready;
    } catch (e) {
      error.value = e.toString();
      status.value = ProductsStatus.error;
    }
  }

  void setQuery(String q) => query.value = q;

  void _applyFilter() {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) {
      filtered.assignAll(items);
    } else {
      filtered.assignAll(items.where((p) => p.title.toLowerCase().contains(q) || p.category.toLowerCase().contains(q)));
    }
  }

  Future<ProductEntity> getById(int id) async {
    final res = await api.dio.get('/products/$id');
    return ProductModel.fromJson((res.data as Map).cast<String, dynamic>());
  }
}
