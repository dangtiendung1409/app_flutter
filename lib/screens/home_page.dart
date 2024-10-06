import 'package:flutter/material.dart';
import '../service/ProductService.dart';
import 'add_product_page.dart';
import 'edit_product_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> products = [];
  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final data = await _productService.getAllProducts();
      setState(() {
        products = List<Map<String, dynamic>>.from(data);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load products: $error')),
      );
    }
  }

  void _navigateToAddProduct() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProductPage()),
    );
    _fetchProducts(); // Cập nhật lại danh sách sau khi thêm sản phẩm mới
  }

  void _navigateToEditProduct(Map<String, dynamic> product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(product: product),
      ),
    );
    _fetchProducts(); // Cập nhật lại danh sách sau khi chỉnh sửa sản phẩm
  }

  void _deleteProduct(int id) async {
    try {
      await _productService.deleteProduct(id);
      setState(() {
        products.removeWhere((product) => product['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product $id deleted')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Dismissible(
              key: Key(product['id'].toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {
                _deleteProduct(product['id']);
              },
              child: Card(
                child: ListTile(
                  title: Text('${product['productName']}'),
                  subtitle: Text('Price: \$${product['price']}, Quantity: ${product['quantity']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _navigateToEditProduct(product);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProduct,
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
