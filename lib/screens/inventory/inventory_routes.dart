import 'package:flutter/material.dart';
import 'inventory_screen.dart';
import 'inventory_details_screen.dart';
import 'add_inventory_item_screen.dart';
import 'edit_inventory_item_screen.dart';
import 'transfer_inventory_screen.dart';
import 'package:erp_2/models/warehouse_model.dart';
import 'package:erp_2/models/inventory_item_model.dart';

class InventoryRoutes {
  static const String inventory = '/inventory';
  static const String inventoryDetails = '/inventory/details';
  static const String addInventoryItem = '/inventory/add';
  static const String editInventoryItem = '/inventory/edit';
  static const String transferInventory = '/inventory/transfer';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      inventory: (context) => const InventoryScreen(),
      inventoryDetails:
          (context) => InventoryDetailsScreen(
            warehouse: ModalRoute.of(context)!.settings.arguments as Warehouse,
          ),
      addInventoryItem:
          (context) => AddInventoryItemScreen(
            warehouseId: ModalRoute.of(context)!.settings.arguments as int,
          ),
      editInventoryItem:
          (context) => EditInventoryItemScreen(
            item: ModalRoute.of(context)!.settings.arguments as InventoryItem,
          ),
      transferInventory:
          (context) => TransferInventoryScreen(
            warehouseId: ModalRoute.of(context)!.settings.arguments as int,
          ),
    };
  }
}
