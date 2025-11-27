import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../provider/cart_provider.dart';
import '../theme/app_theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Color(AppColor.backgroundColor),

      appBar: AppBar(
        backgroundColor: Color(AppColor.appbarColor),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Your Cart',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        bottom: true,
        child:cart.items.isEmpty
          ? Center(
              child: Text(
                'Your cart is empty',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.black87,
                    ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {
                      final it = cart.items[i];

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(AppColor.productCardColor),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Product Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: it.product.image,
                                width: 72,
                                height: 72,
                                fit: BoxFit.contain,
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Title + Price
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    it.product.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '\$${it.product.price.toStringAsFixed(2)} x ${it.quantity}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Colors.grey.shade700,
                                        ),
                                  ),
                                ],
                              ),
                            ),

                            // Quantity Controls
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => cart.changeQuantity(
                                      it.product.id, -1),
                                  icon: Icon(
                                    Icons.remove_circle_outline,
                                    color: Color(AppColor.cartBadgeColor),
                                  ),
                                ),

                                Text(
                                  '${it.quantity}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Color(AppColor.cartBadgeColor),
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),

                                IconButton(
                                  onPressed: () =>
                                      cart.changeQuantity(it.product.id, 1),
                                  icon: Icon(
                                    Icons.add_circle_outline,
                                    color: Color(AppColor.cartBadgeColor),
                                  ),
                                ),

                                // Delete
                                IconButton(
                                  onPressed: () {
                                    cart.removeItem(it.product.id);

                                    Fluttertoast.showToast(
                                      msg: "Item removed",
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Checkout
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(AppColor.productCardColor),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Total Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Colors.grey.shade700,
                                ),
                          ),
                          Text(
                            '\$${cart.totalPrice.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: Color(AppColor.cartBadgeColor),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),

                      // Checkout Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(AppColor.cartBadgeColor),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: cart.items.isEmpty
                            ? null
                            : () {
                                Fluttertoast.showToast(
                                  msg: "Ready to Payment Gateway",
                                  gravity: ToastGravity.BOTTOM,
                                );
                              },
                        child: Text(
                          'Checkout',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    ));
  }
}
