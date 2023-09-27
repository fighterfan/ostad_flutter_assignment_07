import 'package:flutter/material.dart';

void main() {
  runApp(ProductApp());
}

class ProductApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductList(),
    );
  }
}

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Product> products = [
    Product(
      name: 'Apple iPhone 15 Pro Max',
      price: 1199,
    ),
    Product(
      name: 'Google pixel 8 Pro',
      price: 900,
    ),
    Product(
      name: 'Google Pixel 8',
      price: 800,
    ),
    Product(
      name: 'Samsung Galaxy S23 Ultra',
      price: 1600,
    ),
    Product(
      name: 'Apple iPhone 15 Pro',
      price: 800,
    ),
    Product(
      name: 'Samsung Galaxy Z Fold5',
      price: 1700,
    ),
    Product(
      name: 'Samsung Galaxy S22 Ultra 5G',
      price: 1150,
    ),
    Product(
      name: 'Apple iPhone 14 Pro Max',
      price: 1099,
    ),
    Product(
      name: 'Apple iPhone 15 Plus',
      price: 800,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Filter products that have been bought and navigate to CartPage
              final boughtProducts = products.where((product) => product.counter > 0).toList();
              if (boughtProducts.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(boughtProducts: boughtProducts),
                  ),
                );
              } else {
                // Show a message if the cart is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Cart is empty. Buy some products first.'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductItem(
            product: product,
            onBuyPressed: () {
              setState(() {
                product.incrementCounter();
                if (product.counter == 5) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Congratulations!'),
                        content:
                        Text('You\'ve bought 5 ${product.name}!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              });
            },
          );
        },
      ),
    );
  }
}

class Product {
  final String name;
  final double price;
  int counter = 0;

  Product({
    required this.name,
    required this.price,
  });

  void incrementCounter() {
    counter++;
  }
}

class ProductItem extends StatelessWidget {
  final Product product;
  final VoidCallback onBuyPressed;

  ProductItem({
    required this.product,
    required this.onBuyPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
      trailing: Column(
        children: [
          Text('Counter: ${product.counter}'),
          ElevatedButton(
            onPressed: onBuyPressed,
            child: Text('Buy Now'),
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Product> boughtProducts;

  CartPage({
    required this.boughtProducts,
  });

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0.0;

    // Calculate the total price by iterating through boughtProducts
    for (final product in boughtProducts) {
      totalPrice += product.price * product.counter;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: boughtProducts.length,
        itemBuilder: (context, index) {
          final product = boughtProducts[index];
          return ListTile(
            title: Text('${product.name} x ${product.counter}'),
            subtitle: Text('\$${(product.price * product.counter).toStringAsFixed(2)}'),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Total Price: \$${totalPrice.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
