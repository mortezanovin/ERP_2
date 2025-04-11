import 'package:flutter/material.dart';
import 'package:erp_2/models/warehouse_model.dart';
import 'package:erp_2/services/inventory_service.dart';
import 'inventory_details_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  InventoryScreenState createState() => InventoryScreenState();
}

class InventoryScreenState extends State<InventoryScreen> {
  List<Warehouse> _warehouses = [];
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
      setState(() {
        _warehouses = warehouses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('خطا: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مدیریت انبار')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _warehouses.length,
                itemBuilder: (context, index) {
                  final warehouse = _warehouses[index];
                  return ListTile(
                    title: Text(warehouse.name),
                    subtitle: Text(warehouse.description),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  InventoryDetailsScreen(warehouse: warehouse),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
