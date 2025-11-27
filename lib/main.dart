import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/product_provider.dart';
import 'provider/cart_provider.dart';
import 'provider/wishlist_provider.dart';
import 'screens/product_list_screen.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final productProvider = ProductProvider();
  final api = ApiService();

  /// Fetch products before running the app
  final products = await api.fetchProducts();
  productProvider.setProducts(products);

  runApp(MyApp(productProvider: productProvider));
}

class MyApp extends StatelessWidget {
  final ProductProvider productProvider;
  const MyApp({super.key, required this.productProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductProvider>.value(
          value: productProvider,
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: const ProductListScreen(),
      ),
    );
  }
}
