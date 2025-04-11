import 'package:flutter/material.dart';
import 'package:erp_2/models/inventory_item_model.dart';
import 'package:erp_2/services/inventory_service.dart';

class AddInventoryItemScreen extends StatefulWidget {
  final int warehouseId;

  const AddInventoryItemScreen({super.key, required this.warehouseId});

  @override
  AddInventoryItemScreenState createState() => AddInventoryItemScreenState();
}

class AddInventoryItemScreenState extends State<AddInventoryItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  bool _isLoading = false;

  void _addInventoryItem() async {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus(); // بستن کیبورد
      setState(() => _isLoading = true); // نمایش لوادینگ

      try {
        // تبدیل مقادیر ورودی به انواع مناسب
        final name = _nameController.text;
        final code = _codeController.text;
        final category = _categoryController.text;
        final price =
            double.tryParse(_priceController.text) ?? 0.0; // پیش‌فرض 0.0
        final quantity =
            int.tryParse(_quantityController.text) ?? 0; // پیش‌فرض 0

        // ایجاد شیء InventoryItem
        final newItem = InventoryItem(
          id: 0, // ID توسط سرور تعیین می‌شود
          name: name,
          code: code,
          category: category,
          price: price,
          quantity: quantity,
          warehouseId: widget.warehouseId,
        );

        // اضافه کردن کالا به انبار
        await InventoryService.addInventoryItem(newItem);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('کالا با موفقیت اضافه شد')),
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
          setState(() => _isLoading = false); // پنهان کردن لوادینگ
        }
      }
    }
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName الزامیست';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('افزودن کالا')),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'نام کالا'),
                  validator: (value) => _validateField(value, 'نام کالا'),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(labelText: 'کد کالا'),
                  validator: (value) => _validateField(value, 'کد کالا'),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'دسته‌بندی'),
                  validator: (value) => _validateField(value, 'دسته‌بندی'),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'قیمت'),
                  validator: (value) => _validateField(value, 'قیمت'),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'تعداد'),
                  validator: (value) => _validateField(value, 'تعداد'),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add, size: 20),
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
                              'افزودن',
                              style: TextStyle(fontSize: 16),
                            ),
                    onPressed: _addInventoryItem,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
