class InventoryLog {
  final int id;
  final int itemId;
  final int? fromWarehouseId;
  final int? toWarehouseId;
  final int quantity;
  final String actionType;
  final DateTime createdAt;

  InventoryLog({
    required this.id,
    required this.itemId,
    required this.fromWarehouseId,
    required this.toWarehouseId,
    required this.quantity,
    required this.actionType,
    required this.createdAt,
  });

  factory InventoryLog.fromJson(Map<String, dynamic> json) {
    return InventoryLog(
      id: json['id'],
      itemId: json['item_id'],
      fromWarehouseId: json['from_warehouse_id'],
      toWarehouseId: json['to_warehouse_id'],
      quantity: json['quantity'],
      actionType: json['action_type'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_id': itemId,
      'from_warehouse_id': fromWarehouseId,
      'to_warehouse_id': toWarehouseId,
      'quantity': quantity,
      'action_type': actionType,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
