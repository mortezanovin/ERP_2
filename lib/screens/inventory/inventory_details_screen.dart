import 'package:flutter/material.dart';
import 'package:erp_2/models/inventory_item_model.dart';
import 'package:erp_2/services/inventory_service.dart';
import 'add_inventory_item_screen.dart';
import 'edit_inventory_item_screen.dart';
import 'transfer_inventory_screen.dart';
import 'package:erp_2/models/warehouse_model.dart';

class InventoryDetailsScreen extends StatefulWidget {
  final Warehouse warehouse;

  const InventoryDetailsScreen({super.key, required this.warehouse});

  @override
  InventoryDetailsScreenState createState() => InventoryDetailsScreenState();
}

class InventoryDetailsScreenState extends State<InventoryDetailsScreen> {
  List<InventoryItem> _items = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchInventoryItems();
  }

  Future<void> _fetchInventoryItems() async {
    setState(() => _isLoading = true);
    try {
      final items = await InventoryService.fetchInventoryItems(
        widget.warehouse.id,
      );
      if (mounted) {
        // بررسی mounted
        setState(() {
          _items = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        // بررسی mounted
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطا: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.warehouse.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => AddInventoryItemScreen(
                        warehouseId: widget.warehouse.id,
                      ),
                ),
              ).then((_) => _fetchInventoryItems());
            },
          ),
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => TransferInventoryScreen(
                        warehouseId: widget.warehouse.id,
                      ),
                ),
              ).then((_) => _fetchInventoryItems());
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text(
                      'موجودی: ${item.quantity} - قیمت: ${item.price}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // دکمه ویرایش
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        EditInventoryItemScreen(item: item),
                              ),
                            ).then((_) => _fetchInventoryItems());
                          },
                        ),
                        // دکمه حذف
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text('حذف کالا'),
                                    content: const Text(
                                      'آیا مطمئن هستید که می‌خواهید این کالا را حذف کنید؟',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('لغو'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          try {
                                            await InventoryService.deleteInventoryItem(
                                              item.id,
                                            );
                                            if (mounted) {
                                              // بررسی mounted
                                              ScaffoldMessenger.of(
                                                // ignore: use_build_context_synchronously
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'کالا با موفقیت حذف شد',
                                                  ),
                                                ),
                                              );
                                              _fetchInventoryItems(); // به‌روزرسانی لیست کالاها
                                            }
                                          } catch (e) {
                                            if (mounted) {
                                              // بررسی mounted
                                              ScaffoldMessenger.of(
                                                // ignore: use_build_context_synchronously
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text('خطا: $e'),
                                                ),
                                              );
                                            }
                                          }
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                        },
                                        child: const Text('بله'),
                                      ),
                                    ],
                                  ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
