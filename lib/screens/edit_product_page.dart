import 'package:flutter/material.dart';
import '../service/ProductService.dart';

class EditProductPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const EditProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String editedProductName = product['productName'];
    String productPrice = product['price'].toString();
    String productQuantity = product['quantity'].toString();

    final ProductService _productService = ProductService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: editedProductName,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
                onChanged: (value) {
                  editedProductName = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: productPrice,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product price';
                  }
                  return null;
                },
                onChanged: (value) {
                  productPrice = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: productQuantity,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product quantity';
                  }
                  return null;
                },
                onChanged: (value) {
                  productQuantity = value;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _productService.updateProduct(product['id'], {
                      'productName': editedProductName,
                      'price': double.parse(productPrice),
                      'quantity': int.parse(productQuantity),
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Product updated')),
                    );
                    Navigator.pop(context); // Quay lại trang trước
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
