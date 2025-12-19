import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/ui/glass.dart';
import '../../../core/ui/animated_page.dart';
import '../controller/products_controller.dart';
import '../domain/entities/product.dart';
import '../../cart/controller/cart_controller.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  ProductEntity? p;
  String? err;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final idStr = Get.parameters['id'];
    final id = idStr == null ? null : int.tryParse(idStr);
    if (id == null) {
      setState(() => err = 'Invalid product id');
      return;
    }
    try {
      final c = Get.find<ProductsController>();
      final item = await c.getById(id);
      if (!mounted) return;
      setState(() => p = item);
    } catch (e) {
      if (!mounted) return;
      setState(() => err = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(title: Text('products.seeDetails'.tr)),
      body: SafeArea(
        child: FadeSlide(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GlassCard(
              padding: EdgeInsets.zero,
              child: err != null
                  ? Padding(padding: const EdgeInsets.all(16), child: Text('${'products.error'.tr}: $err', style: Theme.of(context).textTheme.bodyMedium))
                  : p == null
                      ? const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator(strokeWidth: 2)))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                AspectRatio(
                                  aspectRatio: 16 / 8,
                                  child: Hero(
                                    tag: 'product-${p!.id}',
                                    child: Image.network(p!.image, fit: BoxFit.cover),
                                  ),
                                ),
                                Positioned.fill(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.7), Colors.transparent]),
                                    ),
                                  ),
                                ),
                                Positioned(top: 12, right: 12, child: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.chevron_right, color: Colors.white))),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(p!.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                _Pill(text: p!.category),
                                                const SizedBox(width: 10),
                                                Text('${'products.rating'.tr}: ${p!.rating.toStringAsFixed(1)}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text('\$${p!.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.primary)),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(p!.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4)),
                                  const SizedBox(height: 14),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () => Get.back(),
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.25)),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                          ),
                                          child: Text('common.back'.tr),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: GradientButton(
                                          onPressed: () async {
                                            await cart.add(p!);
                                            showGlassSnack(context, 'common.added'.tr, desc: p!.title);
                                          },
                                          child: Text('products.addToCart'.tr),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
    );
  }
}
