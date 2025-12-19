import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/ui/glass.dart';
import '../controller/products_controller.dart';
import '../domain/entities/product.dart';
import '../../cart/controller/cart_controller.dart';
import '../../../app/routes/app_routes.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProductsController>();
    final cart = Get.find<CartController>();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('products.title'.tr, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
              const Spacer(),
              IconButton(onPressed: c.fetch, icon: const Icon(Icons.refresh)),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(hintText: 'products.search'.tr, prefixIcon: const Icon(Icons.search)),
            onChanged: c.setQuery,
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Obx(() {
              if (c.status.value == ProductsStatus.loading) {
                return const Center(child: _NiceLoading());
              }
              if (c.status.value == ProductsStatus.error) {
                return Center(child: Text('${'products.error'.tr}: ${c.error.value}', style: Theme.of(context).textTheme.bodyMedium));
              }

              final items = c.filtered;
              if (items.isEmpty) return Center(child: Text('products.empty'.tr, style: Theme.of(context).textTheme.bodyMedium));

              return _MasonryList(
                items: items,
                onAdd: (p) async {
                  await cart.add(p);
                  showGlassSnack(context, 'products.added'.tr, desc: p.title);
                },
              );
            }),
          ),
          const SizedBox(height: 8),
          Text('products.sourceNote'.tr, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
        ],
      ),
    );
  }
}

class _MasonryList extends StatelessWidget {
  final List<ProductEntity> items;
  final ValueChanged<ProductEntity> onAdd;
  const _MasonryList({required this.items, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final List<Widget> blocks = [];
    int i = 0;
    while (i < items.length) {
      if (i + 1 < items.length) {
        blocks.add(Row(
          children: [
            Expanded(child: _ProductCard(p: items[i], onAdd: onAdd, compact: true)),
            const SizedBox(width: 12),
            Expanded(child: _ProductCard(p: items[i + 1], onAdd: onAdd, compact: true)),
          ],
        ));
        i += 2;
      }
      if (i < items.length) {
        blocks.add(_ProductCard(p: items[i], onAdd: onAdd, compact: false));
        i += 1;
      }
    }

    return ListView.separated(
      itemCount: blocks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => blocks[i],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductEntity p;
  final ValueChanged<ProductEntity> onAdd;
  final bool compact;
  const _ProductCard({required this.p, required this.onAdd, required this.compact});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double ratio = compact ? 1.0 : 1.6;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Transform.translate(offset: Offset(0, (1 - t) * 10), child: Opacity(opacity: t, child: child)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: theme.dividerColor.withOpacity(0.16)),
            color: theme.colorScheme.surface.withOpacity(0.85),
            boxShadow: [
              BoxShadow(color: theme.colorScheme.primary.withOpacity(0.05), blurRadius: 30, offset: const Offset(0, 16)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: ratio,
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: Hero(
                          tag: 'product-${p.id}',
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 160),
                            scale: 1,
                            child: Image.network(
                              p.image,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return AnimatedOpacity(
                                  opacity: 0.6,
                                  duration: const Duration(milliseconds: 200),
                                  child: Container(
                                    color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
                                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                  ),
                                );
                              },
                              errorBuilder: (_, __, ___) => Container(color: theme.colorScheme.surfaceVariant),
                            ),
                          ),
                        ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              theme.colorScheme.surface.withOpacity(0.65),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.secondary]),
                        ),
                        child: Text(p.category, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text('\$${p.price.toStringAsFixed(2)}', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w900)),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Color(0xFFFFD166)),
                            const SizedBox(width: 4),
                            Text(p.rating.toStringAsFixed(1), style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _AnimatedBtn(
                            child: OutlinedButton(
                              onPressed: () => Get.toNamed(Routes.details, parameters: {'id': p.id.toString()}),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                minimumSize: const Size.fromHeight(46),
                                textStyle: theme.textTheme.labelLarge?.copyWith(fontSize: 10, fontWeight: FontWeight.w800, height: 1.05),
                                side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.25)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              ),
                              child: Text('products.seeDetails'.tr, textAlign: TextAlign.center),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _AnimatedBtn(
                            child: GradientButton(
                              onPressed: () => onAdd(p),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'products.addToCart'.tr,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
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
    );
  }
}

class _NiceLoading extends StatelessWidget {
  const _NiceLoading();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2)),
        const SizedBox(height: 10),
        Text('common.loading'.tr, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _AnimatedBtn extends StatefulWidget {
  final Widget child;
  const _AnimatedBtn({required this.child});

  @override
  State<_AnimatedBtn> createState() => _AnimatedBtnState();
}

class _AnimatedBtnState extends State<_AnimatedBtn> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _down = true),
      onPointerUp: (_) => setState(() => _down = false),
      child: AnimatedScale(
        scale: _down ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutBack,
        child: widget.child,
      ),
    );
  }
}
