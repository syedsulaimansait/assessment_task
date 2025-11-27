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

    return Scaffold(
      backgroundColor: Color(AppColor.backgroundColor),
      appBar: const _DetailAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProductImage(product: product),
                  _ProductInfoBox(product: product),
                ],
              ),
            ),
          ),
          _BottomActionButtons(product: product, cart: cart),
        ],
      ),
    );
  }
}
class _DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DetailAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      backgroundColor: Color(AppColor.appbarColor),
      elevation: 0.5,
      foregroundColor: Colors.black87,
      title: Text(
        'Product Details',
        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 32,
                    color: Color(AppColor.cartBadgeColor),
                  ),
                  Positioned(
                    top: -5,
                    right: 5,
                    child: AnimatedBuilder(
                      animation: cart,
                      builder: (_, __) => Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Text(
                          cart.itemCount.toString(),
                          style: textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
class _ProductImage extends StatelessWidget {
  final Product product;
  const _ProductImage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'product_${product.id}',
      child: Center(
        child: CachedNetworkImage(
          imageUrl: product.image,
          height: 320,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
class _ProductInfoBox extends StatelessWidget {
  final Product product;
  const _ProductInfoBox({required this.product});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Color(AppColor.productCardColor),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TitleWishlistRow(product: product),
          const SizedBox(height: 12),
          _CategoryRatingRow(product: product),
          const SizedBox(height: 16),

          // PRICE
          Text(
            "\$${product.price.toStringAsFixed(2)}",
            style: textTheme.headlineSmall?.copyWith(
              color: Color(AppColor.cartBadgeColor),
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // DESCRIPTION
          Text(
            product.description,
            style: textTheme.bodyMedium?.copyWith(
              height: 1.4,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
class _TitleWishlistRow extends StatelessWidget {
  final Product product;
  const _TitleWishlistRow({required this.product});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            product.title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Consumer<WishlistProvider>(
          builder: (context, wishlist, _) {
            final isFav = wishlist.isInWishlist(product);
            return GestureDetector(
              onTap: () {
                wishlist.toggleWishlist(product);
                Fluttertoast.showToast(
                  msg: isFav ? "Removed from Wishlist" : "Added to Wishlist",
                  backgroundColor: Colors.black87,
                  textColor: Colors.white,
                );
              },
              child: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.black54,
                size: 28,
              ),
            );
          },
        ),
      ],
    );
  }
}
class _CategoryRatingRow extends StatelessWidget {
  final Product product;
  const _CategoryRatingRow({required this.product});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Chip(
          label: Text(
            product.category,
            style: textTheme.labelLarge?.copyWith(color: Colors.white),
          ),
          backgroundColor: Color(AppColor.cartBadgeColor),
        ),
        const SizedBox(width: 12),
        RatingStars(rating: product.rating),
      ],
    );
  }
}
class _BottomActionButtons extends StatelessWidget {
  final Product product;
  final CartProvider cart;

  const _BottomActionButtons({required this.product, required this.cart});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
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
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => WishlistScreen()),
                  );
                },
                child: Text(
                  'Wishlist',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(AppColor.cartBadgeColor),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(AppColor.cartBadgeColor),
                  foregroundColor: Colors.white,
                ),
                onPressed: () => cart.addItem(product),
                child: Text(
                  'Add to Cart',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
