import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/inventory_item_model.dart';
import '../models/warehouse_model.dart';

class InventoryService {
  static const String baseUrl = 'http://172.16.10.20:5000/api';

  // دریافت لیست انبارها
  static Future<List<Warehouse>> fetchWarehouses() async {
    final response = await http.get(Uri.parse('$baseUrl/warehouses'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Warehouse.fromJson(item)).toList();
    } else {
      throw Exception('خطا در دریافت انبارها');
    }
  }

  // دریافت لیست کالاها
  static Future<List<InventoryItem>> fetchInventoryItems(
    int warehouseId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/inventory?warehouse_id=$warehouseId'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => InventoryItem.fromJson(item)).toList();
    } else {
      throw Exception('خطا در دریافت کالاها');
    }
  }

  // افزودن کالای جدید
  static Future<void> addInventoryItem(InventoryItem item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/inventory'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(item.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('خطا در افزودن کالا');
    }
  }

  // به‌روزرسانی کالا
  static Future<void> updateInventoryItem(InventoryItem item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/inventory/${item.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(item.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('خطا در به‌روزرسانی کالا');
    }
  }

  // حذف کالا
  static Future<void> deleteInventoryItem(int itemId) async {
    final response = await http.delete(Uri.parse('$baseUrl/inventory/$itemId'));
    if (response.statusCode != 200) {
      throw Exception('خطا در حذف کالا');
    }
  }

  // انتقال کالا بین انبارها
  static Future<void> transferInventoryItem({
    required int itemId,
    required int fromWarehouseId,
    required int toWarehouseId,
    required int quantity,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/inventory/transfer'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'item_id': itemId,
        'from_warehouse_id': fromWarehouseId,
        'to_warehouse_id': toWarehouseId,
        'quantity': quantity,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('خطا در انتقال کالا');
    }
  }
}
