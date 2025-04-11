import 'package:flutter/material.dart';
import 'package:erp_2/models/warehouse_model.dart';
import 'package:erp_2/models/inventory_item_model.dart';
import 'package:erp_2/services/inventory_service.dart';

class TransferInventoryScreen extends StatefulWidget {
  final int warehouseId;

  const TransferInventoryScreen({super.key, required this.warehouseId});

  @override
  TransferInventoryScreenState createState() => TransferInventoryScreenState();
}

class TransferInventoryScreenState extends State<TransferInventoryScreen> {
  List<Warehouse> _warehouses = [];
  InventoryItem? _selectedItem;
  int? _toWarehouseId;
  int _quantity = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWarehouses();
  }

  Future<void> _fetchWarehouses() async {
    setState(() => _isLoading = true);
    try {
      final warehouses = await InventoryService.fetchWarehouses();
      if (mounted) {
        setState(() {
          _warehouses =
              warehouses.where((w) => w.id != widget.warehouseId).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطا: $e')));
      }
    }
  }

  void _transferInventory() async {
    if (_selectedItem == null || _toWarehouseId == null || _quantity <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لطفاً تمام فیلدها را پر کنید')),
        );
      }
      return;
    }

    setState(() => _isLoading = true);
    try {
      await InventoryService.transferInventoryItem(
        itemId: _selectedItem!.id,
        fromWarehouseId: widget.warehouseId,
        toWarehouseId: _toWarehouseId!,
        quantity: _quantity,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('کالا با موفقیت منتقل شد')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطا: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('انتقال کالا')),
        body:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<Warehouse>(
                        decoration: const InputDecoration(
                          labelText: 'انبار مقصد',
                        ),
                        items:
                            _warehouses.map((w) {
                              return DropdownMenuItem(
                                value: w,
                                child: Text(w.name),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() => _toWarehouseId = value?.id);
                        },
                        validator:
                            (value) =>
                                value == null
                                    ? 'انتخاب انبار مقصد الزامیست'
                                    : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'تعداد'),
                        onChanged:
                            (value) => _quantity = int.tryParse(value) ?? 0,
                        validator:
                            (value) =>
                                value == null ||
                                        int.tryParse(value) == null ||
                                        int.parse(value) <= 0
                                    ? 'تعداد معتبر وارد کنید'
                                    : null,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.swap_horiz, size: 20),
                          label:
                              _isLoading
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text(
                                    'انتقال',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          onPressed: _transferInventory,
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
