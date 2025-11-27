import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../model/product_model.dart';
import '../provider/cart_provider.dart';
import '../widgets/rating_stars.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: Color(0xFF9ccddb),
      appBar: AppBar(
        backgroundColor: Color(0xFF9ccddb),
        elevation: 0.5,
        foregroundColor: Colors.black87,
        title: Text(
          'Product Details',
          style: textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
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
                      color: Color(0xffd0d7e1),
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
                        // Title
                        Text(
                          product.title,
                          style: textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Category + Rating
                        Row(
                          children: [
                            Chip(
                              label: Text(
                                product.category,
                                style: const TextStyle(fontWeight: FontWeight.w500,color: Colors.white),
                              ),
                              backgroundColor:  Color(0xFF064469),
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
                            color: Color(0xFF064469),
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
                color: Color(0xffd0d7e1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, -1),
                  )
                ],
              ),
              child: Row(
                children: [
                  // Wishlist Button
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color:  Color(0xFF064469)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Wishlist',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF064469)
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
                        backgroundColor:  Color(0xFF064469),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        cart.addItem(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added to Cart'),
                            behavior: SnackBarBehavior.floating,
                          ),
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
          )
        ],
      ),
    );
  }
}
