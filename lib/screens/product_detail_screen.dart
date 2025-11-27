import 'package:assessment_task/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../model/product_model.dart';
import '../provider/cart_provider.dart';
import '../provider/wishlist_provider.dart';
import '../widgets/rating_stars.dart';
import 'cart_screen.dart';
import 'wishlist_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<CartProvider>(context, listen: false);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: Color(AppColor.backgroundColor),
      appBar: AppBar(
        backgroundColor: Color(AppColor.backgroundColor),
        elevation: 0.5,
        foregroundColor: Colors.black87,
        title: Text(
          'Product Details',
          style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          // 🔵 CENTER CART ICON BUTTON (REPLACES FAB)
          Center(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 32, color: Color(AppColor.cartBadgeColor)),

                  // 🔴 Cart Badge
                  Positioned(
                    top: 10,
                    right: 10,
                    child: AnimatedBuilder(
                      animation: cart,
                      builder: (_, __) {
                        return Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Text(
                            cart.itemCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- IMAGE ----------
                  Hero(
                    tag: 'product_${product.id}',
                    child: Center(
                      child: Container(
                        //color: Colors.white,
                        child: CachedNetworkImage(
                          imageUrl: product.image,
                          height: 320,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  // ---------- CONTENT BOX ----------
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Color(AppColor.productCardColor),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔥 TITLE + HEART WISHLIST BUTTON
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Expanded(
                              child: Text(
                                product.title,
                                style: textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // ❤️ Wishlist toggle
                            Consumer<WishlistProvider>(
                              builder: (context, wishlist, _) {
                                final isFav = wishlist.isInWishlist(product);

                                return GestureDetector(
                                  onTap: () {
                                    wishlist.toggleWishlist(product);

                                    Fluttertoast.showToast(
                                      msg: isFav
                                          ? "Removed from Wishlist"
                                          : "Added to Wishlist",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.black87,
                                      textColor: Colors.white,
                                    );
                                  },
                                  child: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFav ? Colors.red : Colors.black54,
                                    size: 28,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Category + Rating
                        Row(
                          children: [
                            Chip(
                              label: Text(
                                product.category,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Color(AppColor.cartBadgeColor),
                              side: BorderSide(color: Colors.teal.shade200),
                            ),
                            const SizedBox(width: 12),
                            RatingStars(rating: product.rating),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Price
                        Text(
                          "\$${product.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(AppColor.cartBadgeColor),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Description
                        Text(
                          product.description,
                          style: textTheme.bodyMedium!.copyWith(
                            height: 1.4,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---------- BOTTOM BUTTONS ----------
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(AppColor.productCardColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Wishlist Button
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Fluttertoast.showToast(
                          msg: "Added to Wishlist",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.black87,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => WishlistScreen()),
                        );
                      },
                      child: const Text(
                        'Wishlist',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(AppColor.cartBadgeColor),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Add to cart
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(AppColor.cartBadgeColor),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        cart.addItem(product);

                        Fluttertoast.showToast(
                          msg: "Added to Cart",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.black87,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      },
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
