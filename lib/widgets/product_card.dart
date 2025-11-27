import 'package:assessment_task/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../model/product_model.dart';
import '../screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isList;

  const ProductCard({
    super.key,
    required this.product,
    required this.isList,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1E2A34)
              : Color(AppColor.productCardColor),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            if (!isDark)
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProductImage(product: product),
            _ProductTitle(product: product, textTheme: textTheme),
            _ProductPrice(product: product, isDark: isDark, textTheme: textTheme),
          ],
        ),
      ),
    );
  }
}
class _ProductImage extends StatelessWidget {
  final Product product;
  const _ProductImage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Hero(
        tag: 'product_${product.id}',
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          child: Image.network(
            product.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
class _ProductTitle extends StatelessWidget {
  final Product product;
  final TextTheme textTheme;

  const _ProductTitle({
    required this.product,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
      child: Text(
        product.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}
class _ProductPrice extends StatelessWidget {
  final Product product;
  final bool isDark;
  final TextTheme textTheme;

  const _ProductPrice({
    required this.product,
    required this.isDark,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: Text(
        "\$${product.price}",
        style: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.tealAccent : Colors.black,
        ),
      ),
    );
  }
}
