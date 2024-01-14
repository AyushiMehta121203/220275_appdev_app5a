import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Cart(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Cart',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: const ProductListPage(),
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  bool isInCart;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.isInCart = false,
  });
}

final List<Product> products = [
  Product(
    id: 'P1',
    name: 'Ceramic Printed Coffee Mug',
    image:
        'https://picsum.photos/id/30/367/267',
    price: 2,
  ),
  Product(
    id: 'P2',
    name: 'Table Clock',
    image:
        'https://picsum.photos/id/175/367/267',
    price: 3,
  ),
  Product(
    id: 'P3',
    name: 'Tea Dispenser',
    image:
        'https://picsum.photos/id/225/367/267',
    price: 60,
  ),
  Product(
    id: 'P4',
    name: 'Black Cannon Camera',
    image:
        'https://picsum.photos/id/250/367/267',
    price: 360,
  ),
  Product(
    id: 'P5',
    name:'All-new Kindle' ,
    image:
        'https://picsum.photos/id/367/367/267',
    price: 108,
  ),
  Product(
    id: 'P6',
    name: 'Keyboard',
    image:
        'https://picsum.photos/id/366/367/267',
    price: 8,
  ),
  Product(
    id: 'P7',
    name: 'Apple MacBook Air 13',
    image:
        'https://picsum.photos/id/48/367/267',
    price: 1200,
  ),
  Product(
    id: 'P8',
    name: 'Elegant Women Bellies',
    image:
        'https://picsum.photos/id/21/367/267',
    price: 48,
  ),
  Product(
    id: 'P9',
    name: 'Cycle',
    image:
        'https://picsum.photos/id/146/367/267',
    price: 72 ,
  ),
  Product(
    id: 'P10',
    name: 'MacBook Air M1',
    image:
        'https://picsum.photos/id/8/367/267',
    price: 800,
  ),
];

class Cart extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.price);

  void addProduct(Product product) {
    if (!_items.contains(product)) {
      product.isInCart = true;
      _items.add(product);
      notifyListeners();
    }
  }

  void removeProduct(Product product) {
    if (_items.contains(product)) {
      product.isInCart = false;
      _items.remove(product);
      notifyListeners();
    }
  }

  void clearCart() {
    for (var product in products) {
      product.isInCart = false;
    }
    _items.clear();
    notifyListeners();
  }

  double totalAmt() {
    double tot = 0;
    for (var product in products) {
      tot = tot + product.price;
    }
    return tot;
  }
}

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: Consumer<Cart>(
        builder: (context, cart, child) {
          return ListView.builder(
            padding: const EdgeInsets.all(30.0),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: Image.network(product.image),
                title: Text(product.name),
                subtitle: Text('\$${product.price}'),
                trailing: IconButton(
                  icon: product.isInCart
                      ? const Icon(Icons.remove_circle)
                      : const Icon(Icons.add_circle),
                  onPressed: () {
                    if (product.isInCart) {
                      cart.removeProduct(product);
                    } else {
                      cart.addProduct(product);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Consumer<Cart>(
        builder: (context, cart, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final product = cart.items[index];
                    return ListTile(
                      leading: Image.network(product.image),
                      title: Text(product.name),
                      subtitle: Text('\$${product.price}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () {
                          cart.removeProduct(product);
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Text('BUY'),
            onPressed: () {
              Provider.of<Cart>(context, listen: false).clearCart();
            },
          ),
        ],
      ),
    );
  }
}