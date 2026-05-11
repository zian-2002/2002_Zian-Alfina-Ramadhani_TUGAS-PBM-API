import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

import '../config/api_config.dart';

class ProductService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<List<ProductModel>> getProducts(String token) async {
    final url = Uri.parse('$baseUrl/products');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    print('DEBUG: API Response Status: ${response.statusCode}');
    print('DEBUG: API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // Coba cari list di data['data'] atau data['data']['products']
      dynamic productsData;
      if (data['data'] is List) {
        productsData = data['data'];
      } else if (data['data'] is Map && data['data']['products'] is List) {
        productsData = data['data']['products'];
      }

      if (productsData is List) {
        return productsData.map((e) => ProductModel.fromJson(e)).toList();
      }
    }

    return [];
  }

  Future<bool> addProduct(String token, ProductModel product) async {
    final url = Uri.parse('$baseUrl/products');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(product.toJson()),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> submitProduct(String token, ProductModel product) async {
    final url = Uri.parse('$baseUrl/products/submit');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(product.toJson()),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
