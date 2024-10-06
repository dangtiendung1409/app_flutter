import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  final String apiUrl = 'http://10.0.2.2:8065/api/products';

  // Lấy danh sách tất cả sản phẩm
  Future<List<dynamic>> getAllProducts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Thêm sản phẩm mới
  Future<void> addProduct(Map<String, dynamic> product) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add product');
    }
  }

  // Chỉnh sửa sản phẩm
  Future<void> updateProduct(int id, Map<String, dynamic> product) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }

  // Xóa sản phẩm
  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete product');
    }
  }
}
