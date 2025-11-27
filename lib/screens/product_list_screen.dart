import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';
import '../provider/product_provider.dart';
import '../provider/wishlist_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/shimmer_card.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';
import 'wishlist_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen>
    with TickerProviderStateMixin {
  bool showSearch = false;
  String searchQuery = "";
  bool isGrid = true;
  int _selectedIndex = 0;

  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => WishlistScreen()),
      );
    }
  }

  Widget _buildBottomItem({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 26, color: Colors.black),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 11,
              color: Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  List<dynamic> getFilteredProducts(ProductProvider store) {
    if (searchQuery.isEmpty) return store.products;

    return store.products.where((p) {
      return p.title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final productStore = Provider.of<ProductProvider>(context);
    final filteredProducts = getFilteredProducts(productStore);
    final cartProv = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Color(AppColor.backgroundColor),
      extendBody: true,

      appBar: AppBar(
        backgroundColor: Color(AppColor.appbarColor),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Products",
          style: GoogleFonts.roboto(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              setState(() {
                showSearch = !showSearch;
                if (showSearch) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                  searchQuery = "";
                }
              });
            },
          ),

          IconButton(
            icon: Icon(
              isGrid ? Icons.list_rounded : Icons.grid_view_rounded,
              color: Colors.black,
            ),
            onPressed: () => setState(() => isGrid = !isGrid),
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          backgroundColor: Color(AppColor.cartBadgeColor),
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CartScreen()),
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined,
                  size: 30, color: Color(AppColor.appbarColor)),
              Positioned(
                top: -5,
                right: 3,
                child: AnimatedBuilder(
                  animation: cartProv,
                  builder: (_, __) {
                    return Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: Text(
                        cartProv.itemCount.toString(),
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 10,
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

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        color: Color(AppColor.appbarColor),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomItem(
                label: 'Home',
                icon: Icons.home,
                isSelected: _selectedIndex == 0,
                onTap: () => _onItemTapped(0),
              ),
              const SizedBox(width: 40),
              _buildBottomItem(
                label: 'Favorites',
                icon: Icons.favorite_border,
                isSelected: _selectedIndex == 2,
                onTap: () => _onItemTapped(2),
              ),
            ],
          ),
        ),
      ),

      body: Column(
        children: [
          SizeTransition(
            sizeFactor: _expandAnimation,
            axisAlignment: -1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) => setState(() => searchQuery = value),
                  style: GoogleFonts.roboto(),
                  decoration: InputDecoration(
                    hintText: "Search products...",
                    hintStyle: GoogleFonts.roboto(),
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: productStore.isLoading
                  ? _buildShimmer(isGrid)
                  : filteredProducts.isEmpty
                      ? Center(
                          child: Text(
                            "No products found",
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : isGrid
                          ? _buildGridView(filteredProducts)
                          : _buildListView(filteredProducts),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<dynamic> products) {
    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: .68,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
      ),
      itemBuilder: (context, index) => _productCard(products[index]),
    );
  }

  Widget _buildListView(List<dynamic> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (_, index) {
        final product = products[index];

        return Card(
          color: Color(AppColor.productCardColor),
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Hero(
              tag: 'product_${product.id}',
              child: Image.network(product.image, width: 60, height: 60),
            ),

            title: Text(
              product.title,
              maxLines: 1,
              style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
            ),

            subtitle: Text(
              "\$${product.price}",
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(product: product),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildShimmer(bool isGrid) {
    if (isGrid) {
      return GridView.builder(
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .68,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
        ),
        itemBuilder: (_, __) => ShimmerCard(),
      );
    }
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: ShimmerCard(),
      ),
    );
  }

  Widget _productCard(product) {
    final wishlist = Provider.of<WishlistProvider>(context);

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
          color: Color(AppColor.productCardColor),
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Hero(
                tag: 'product_${product.id}',
                child: Image.network(product.image, fit: BoxFit.contain),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
              child: Text(
                product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${product.price}",
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  GestureDetector(
                    onTap: () => wishlist.toggleWishlist(product),
                    child: Icon(
                      wishlist.isInWishlist(product)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: wishlist.isInWishlist(product)
                          ? Colors.red
                          : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
