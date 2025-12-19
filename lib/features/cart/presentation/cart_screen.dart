import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/ui/glass.dart';
import '../controller/cart_controller.dart';
import '../domain/entities/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return GlassCard(
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('cart.title'.tr, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: cart.items.isEmpty
                      ? null
                      : () async {
                          await cart.clear();
                          showGlassSnack(context, 'cart.removed'.tr);
                        },
                  style: OutlinedButton.styleFrom(side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.2)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                  icon: const Icon(Icons.delete_outline),
                  label: Text('cart.clear'.tr, style: const TextStyle(fontWeight: FontWeight.w800)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (cart.items.isEmpty)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.16)),
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('cart.empty'.tr, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 6),
                      Text('products.search'.tr, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) => _Item(i: cart.items[i]),
                ),
              ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.16)),
                color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('cart.total'.tr, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                      const Spacer(),
                      Text('\$${cart.total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GradientButton(
                    onPressed: cart.items.isEmpty ? null : () => showGlassSnack(context, 'cart.saved'.tr, desc: '(local)'),
                    child: Text('متابعة الشراء'.tr),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _Item extends StatelessWidget {
  final CartItemEntity i;
  const _Item({required this.i});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.16)),
        color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network(i.product.image, width: 72, height: 72, fit: BoxFit.cover)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(i.product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    Text('\$${i.product.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  await cart.remove(i.product.id);
                  showGlassSnack(context, 'cart.removed'.tr);
                },
                icon: const Icon(Icons.delete_outline),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _QtyBtn(text: '−', onTap: () => cart.dec(i.product.id)),
              const SizedBox(width: 10),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                child: Text(i.qty.toString(), key: ValueKey(i.qty), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
              ),
              const SizedBox(width: 10),
              _QtyBtn(text: '+', onTap: () => cart.inc(i.product.id)),
              const Spacer(),
              Text('\$${i.subtotal.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
            ],
          )
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _QtyBtn({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 44,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.16)),
          color: Theme.of(context).colorScheme.surface.withOpacity(0.6),
        ),
        child: Center(child: Text(text, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900))),
      ),
    );
  }
}
