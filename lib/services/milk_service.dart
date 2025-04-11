import 'dart:convert';
import 'package:http/http.dart' as http;

class MilkService {
  static const String baseUrl = 'http://172.16.10.20:5000/api'; // آدرس سرور

  // دریافت لیست خریدها
  Future<List<dynamic>> fetchPurchases() async {
    final response = await http.get(Uri.parse('$baseUrl/milk-purchase'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('خطا در دریافت اطلاعات خرید');
    }
  }

  // افزودن خرید جدید
  Future<void> addPurchase({
    required String date,
    required String time,
    required String farmerName,
    required double weight,
    required double fatPercentage,
    required double waterPercentage,
    required double protein,
    required double lactose,
    required double acidity,
    required double dryMatter,
    required double density,
    required double freezingPoint,
    required String description,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/milk-purchase'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'date': date,
        'time': time,
        'farmer_name': farmerName,
        'weight': weight,
        'fat_percentage': fatPercentage,
        'water_percentage': waterPercentage,
        'protein': protein,
        'lactose': lactose,
        'acidity': acidity,
        'dry_matter': dryMatter,
        'density': density,
        'freezing_point': freezingPoint,
        'description': description,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('خطا در ثبت خرید');
    }
  }

  // به‌روزرسانی خرید
  Future<void> updatePurchase({
    required String id,
    required String date,
    required String time,
    required String farmerName,
    required double weight,
    required double fatPercentage,
    required double waterPercentage,
    required double protein,
    required double lactose,
    required double acidity,
    required double dryMatter,
    required double density,
    required double freezingPoint,
    required String description,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/milk-purchase/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'date': date,
        'time': time,
        'farmer_name': farmerName,
        'weight': weight,
        'fat_percentage': fatPercentage,
        'water_percentage': waterPercentage,
        'protein': protein,
        'lactose': lactose,
        'acidity': acidity,
        'dry_matter': dryMatter,
        'density': density,
        'freezing_point': freezingPoint,
        'description': description,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('خطا در به‌روزرسانی خرید');
    }
  }

  // حذف خرید
  Future<void> deletePurchase({required String id}) async {
    final response = await http.delete(Uri.parse('$baseUrl/milk-purchase/$id'));
    if (response.statusCode != 200) {
      throw Exception('خطا در حذف خرید');
    }
  }

  // دریافت لیست فروش‌ها
  Future<List<dynamic>> fetchSales() async {
    final response = await http.get(Uri.parse('$baseUrl/milk-sale'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('خطا در دریافت اطلاعات فروش');
    }
  }

  // افزودن فروش جدید
  Future<void> addSale({
    required String date,
    required String time,
    required String customerName,
    required double weight,
    required double fatPercentage,
    required double waterPercentage,
    required double protein,
    required double lactose,
    required double acidity,
    required double dryMatter,
    required double density,
    required double freezingPoint,
    required String description,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/milk-sale'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'date': date,
        'time': time,
        'customer_name': customerName,
        'weight': weight,
        'fat_percentage': fatPercentage,
        'water_percentage': waterPercentage,
        'protein': protein,
        'lactose': lactose,
        'acidity': acidity,
        'dry_matter': dryMatter,
        'density': density,
        'freezing_point': freezingPoint,
        'description': description,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('خطا در ثبت فروش');
    }
  }

  // به‌روزرسانی فروش
  Future<void> updateSale({
    required String id,
    required String date,
    required String time,
    required String customerName,
    required double weight,
    required double fatPercentage,
    required double waterPercentage,
    required double protein,
    required double lactose,
    required double acidity,
    required double dryMatter,
    required double density,
    required double freezingPoint,
    required String description,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/milk-sale/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'date': date,
        'time': time,
        'customer_name': customerName,
        'weight': weight,
        'fat_percentage': fatPercentage,
        'water_percentage': waterPercentage,
        'protein': protein,
        'lactose': lactose,
        'acidity': acidity,
        'dry_matter': dryMatter,
        'density': density,
        'freezing_point': freezingPoint,
        'description': description,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('خطا در به‌روزرسانی فروش');
    }
  }

  // حذف فروش
  Future<void> deleteSale({required String id}) async {
    final response = await http.delete(Uri.parse('$baseUrl/milk-sale/$id'));
    if (response.statusCode != 200) {
      throw Exception('خطا در حذف فروش');
    }
  }

  // دریافت خریدها بر اساس بازه تاریخ
  Future<List<dynamic>> fetchPurchasesByDate(
    String startDate,
    String endDate,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/milk-purchase?start_date=$startDate&end_date=$endDate',
      ),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('خطا در دریافت اطلاعات خرید');
    }
  }

  // دریافت فروش‌ها بر اساس بازه تاریخ
  Future<List<dynamic>> fetchSalesByDate(
    String startDate,
    String endDate,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/milk-sale?start_date=$startDate&end_date=$endDate'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('خطا در دریافت اطلاعات فروش');
    }
  }

  // دریافت عکس دامدار (اضافه شده به کلاس)
  Future<String> getFarmerImage(String farmerName) async {
    final response = await http.get(
      Uri.parse('$baseUrl/farmers/$farmerName/image'),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('خطا در دریافت عکس دامدار');
    }
  }

  // دریافت عکس مشتری (اضافه شده به کلاس)
  Future<String> getCustomerImage(String customerName) async {
    final response = await http.get(
      Uri.parse('$baseUrl/customers/$customerName/image'),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('خطا در دریافت عکس مشتری');
    }
  }
}
