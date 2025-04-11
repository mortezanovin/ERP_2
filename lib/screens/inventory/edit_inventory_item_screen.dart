import 'package:flutter/material.dart';
import 'package:erp_2/models/inventory_item_model.dart';
import 'package:erp_2/services/inventory_service.dart';

class EditInventoryItemScreen extends StatefulWidget {
  final InventoryItem item;

  const EditInventoryItemScreen({super.key, required this.item});

  @override
  EditInventoryItemScreenState createState() => EditInventoryItemScreenState();
}

class EditInventoryItemScreenState extends State<EditInventoryItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _codeController = TextEditingController(text: widget.item.code);
    _categoryController = TextEditingController(text: widget.item.category);
    _priceController = TextEditingController(
      text: widget.item.price.toString(),
    );
    _quantityController = TextEditingController(
      text: widget.item.quantity.toString(),
    );
  }

  void _updateInventoryItem() async {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      setState(() => _isLoading = true);

      try {
        final updatedItem = InventoryItem(
          id: widget.item.id,
          name: _nameController.text,
          code: _codeController.text,
          category: _categoryController.text,
          price: double.parse(_priceController.text),
          quantity: int.parse(_quantityController.text),
          warehouseId: widget.item.warehouseId,
        );

        await InventoryService.updateInventoryItem(updatedItem);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('کالا با موفقیت به‌روزرسانی شد')),
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
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('ویرایش کالا')),
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
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'نام کالا الزامیست'
                              : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(labelText: 'کد کالا'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'کد کالا الزامیست'
                              : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'دسته‌بندی'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'دسته‌بندی الزامیست'
                              : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'قیمت'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'قیمت الزامیست'
                              : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'تعداد'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'تعداد الزامیست'
                              : null,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save, size: 20),
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
                              'ذخیره',
                              style: TextStyle(fontSize: 16),
                            ),
                    onPressed: _updateInventoryItem,
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
