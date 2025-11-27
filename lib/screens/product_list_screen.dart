import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';
import '../provider/product_provider.dart';
import '../widgets/shimmer_card.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool isLoading = true;
  bool isGrid = true;

  final Color appColor = Color(0xFF064469); // CHANGE COLOR HERE

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productStore = Provider.of<ProductProvider>(context);
    final cartProv = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFF9ccddb),
      extendBody: true,

      appBar: AppBar(
        backgroundColor: appColor,
        elevation: 0,
        leading: Icon(Icons.menu, color: Colors.white),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) =>
                  RotationTransition(turns: anim, child: child),
              child: Icon(
                isGrid ? Icons.list_rounded : Icons.grid_view_rounded,
                key: ValueKey(isGrid),
              ),
            ),
            onPressed: () => setState(() => isGrid = !isGrid),
          ),
        ],
      ),

      // ⭐ Floating Action Button
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          elevation: 6,
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 32, color: appColor),
              // Cart badge
              Positioned(
                top: 8,
                right: 8,
                child: AnimatedBuilder(
                  animation: cartProv,
                  builder: (_, __) {
                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: Text(
                        cartProv.itemCount.toString(),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ⭐ Custom Bottom Navigation Bar
      bottomNavigationBar: Stack(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: appColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
          ),

          // CURVED CUTOUT
          // Center(
          //   heightFactor: 0.5,
          //   child: Container(
          //     height: 60,
          //     //width: 150,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       shape: BoxShape.circle,
          //     ),
          //   ),
          // ),

          // NAV ICONS
          SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.home, color: Colors.white, size: 30),
                  onPressed: () {},
                ),
                SizedBox(width: 60), // Gap for FAB
                IconButton(
                  icon: Icon(Icons.person, color: Colors.white, size: 30),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: productStore.isLoading
                  ? GridView.builder(
                      itemCount: 6,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: .68,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 18,
                          ),
                      itemBuilder: (context, index) {
                        return ShimmerCard();
                      },
                    )
                  : GridView.builder(
                      itemCount: productStore.products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: .68,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 18,
                          ),
                      itemBuilder: (context, index) {
                        final product = productStore.products[index];
                        return _productCard(product);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Product Card
  Widget _productCard(product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffd0d7e1),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'product_${product.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                  child: Image.network(product.image, fit: BoxFit.cover),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
              child: Text(
                product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Text(
                "\$${product.price}",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
