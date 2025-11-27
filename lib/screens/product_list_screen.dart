import 'package:flutter/material.dart';
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
  bool isSearching = false;
  String searchQuery = "";
  bool showSearch = false;
  bool isLoading = true;
  bool isGrid = true;
  int _selectedIndex = 0;

  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

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
          Icon(
            icon,
            size: 26,
            color: isSelected ? Colors.white : Colors.white70,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? Colors.white : Colors.white70,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    isLoading = false;
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
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

      // appBar: AppBar(
      //   backgroundColor: Color(AppColor.appbarColor),
      //   elevation: 0,
      //   //leading: Icon(Icons.menu, color: Colors.white),
      //   actions: [
      //     IconButton(
      //       icon: AnimatedSwitcher(
      //         duration: const Duration(milliseconds: 200),
      //         transitionBuilder: (child, anim) =>
      //             RotationTransition(turns: anim, child: child),
      //         child: Icon(
      //           isGrid ? Icons.list_rounded : Icons.grid_view_rounded,
      //           key: ValueKey(isGrid),
      //           color: Colors.white,
      //         ),
      //       ),
      //       onPressed: () => setState(() => isGrid = !isGrid),
      //     ),
      //   ],
      // ),
      appBar: AppBar(
        backgroundColor: Color(AppColor.appbarColor),
        elevation: 0,
        title: isSearching
            ? TextField(
                autofocus: true,
                onChanged: (value) {
                  setState(() => searchQuery = value);
                },
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Search products...",
                  
                  hintStyle: TextStyle(color: Colors.white70,),
                  border: InputBorder.none,
                ),
              )
            : const Text("Products", style: TextStyle(color: Colors.white)),

        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                showSearch = !showSearch;
                if (showSearch) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                  searchQuery = ""; // clear search
                }
              });
            },
          ),

          // Grid/List toggle
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) =>
                  RotationTransition(turns: anim, child: child),
              child: Icon(
                isGrid ? Icons.list_rounded : Icons.grid_view_rounded,
                key: ValueKey(isGrid),
                color: Colors.white,
              ),
            ),
            onPressed: () => setState(() => isGrid = !isGrid),
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ⭐ Floating Action Button (Cart Button)
      floatingActionButton: SizedBox(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          backgroundColor: Color(AppColor.cartBadgeColor),
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
              Icon(
                Icons.shopping_cart_outlined,
                size: 30,
                color: Color(AppColor.appbarColor),
              ),

              // Badge
              Positioned(
                top: 8,
                right: 8,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
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

      // ⭐ Bottom Navigation Bar with Notch
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
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

              const SizedBox(width: 40), // space for the FAB

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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() => searchQuery = value);
                  },
                  decoration: const InputDecoration(
                    hintText: "Search products...",
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 12),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: productStore.isLoading
                  ? _buildShimmer(isGrid)
                  : filteredProducts.isEmpty
                  ? const Center(
                      child: Text(
                        "No products found",
                        style: TextStyle(
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
      itemBuilder: (context, index) {
        final product = products[index];
        return _productCard(product);
      },
    );
  }

  Widget _buildListView(List<dynamic> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            title: Text(
              product.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),

            subtitle: Text(
              "\$${product.price}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    } else {
      return ListView.builder(
        itemCount: 6,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: ShimmerCard(),
        ),
      );
    }
  }

  // Product Card
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
          color: const Color(AppColor.productCardColor),
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
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                  child: Image.network(product.image, fit: BoxFit.contain),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
              child: Text(
                product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${product.price}",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
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
