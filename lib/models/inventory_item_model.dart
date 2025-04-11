class InventoryItem {
  final int id;
  final String name;
  final String code;
  final String category;
  final double price;
  final int quantity;
  final DateTime? expiryDate;
  final int? warehouseId;

  InventoryItem({
    required this.id,
    required this.name,
    required this.code,
    required this.category,
    required this.price,
    required this.quantity,
    this.expiryDate,
    this.warehouseId,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 0,
      expiryDate:
          json['expiry_date'] != null
              ? DateTime.parse(json['expiry_date'])
              : null,
      warehouseId: json['warehouse_id'], // مقدار می‌تواند null باشد
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'code': code,
      'category': category,
      'price': price,
      'quantity': quantity,
    };

    // اضافه کردن مقادیر nullable فقط اگر مقدار داشته باشند
    if (expiryDate != null) {
      data['expiry_date'] = expiryDate!.toIso8601String();
    }
    if (warehouseId != null) {
      data['warehouse_id'] =
          warehouseId; // اطمینان حاصل کنید که warehouseId مقدار دارد
    }

    return data;
  }
}
