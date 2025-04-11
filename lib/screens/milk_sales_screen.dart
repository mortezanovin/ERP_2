import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:erp_2/services/milk_service.dart';

class MilkSaleScreen extends StatefulWidget {
  const MilkSaleScreen({super.key});

  @override
  MilkSaleScreenState createState() => MilkSaleScreenState();
}

class MilkSaleScreenState extends State<MilkSaleScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _fatPercentageController =
      TextEditingController();
  final TextEditingController _waterPercentageController =
      TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _lactoseController = TextEditingController();
  final TextEditingController _acidityController = TextEditingController();
  final TextEditingController _dryMatterController = TextEditingController();
  final TextEditingController _densityController = TextEditingController();
  final TextEditingController _freezingPointController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final MilkService _milkService = MilkService();
  List<dynamic> _sales = [];
  String _customerImageUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchSales();
    _setDateTime();
  }

  void _setDateTime() {
    final now = DateTime.now();
    _dateController.text = DateFormat('yyyy-MM-dd').format(now);
    _timeController.text = DateFormat('HH:mm').format(now);
  }

  Future<void> _fetchSales() async {
    try {
      final sales = await _milkService.fetchSales();
      if (mounted) setState(() => _sales = sales);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطا: $e')));
      }
    }
  }

  Future<void> _addSale() async {
    if (!_validateInputs()) return;
    try {
      await _milkService.addSale(
        date: _dateController.text,
        time: _timeController.text,
        customerName: _customerNameController.text,
        weight: double.parse(_weightController.text),
        fatPercentage: double.parse(_fatPercentageController.text),
        waterPercentage: double.parse(_waterPercentageController.text),
        protein: double.parse(_proteinController.text),
        lactose: double.parse(_lactoseController.text),
        acidity: double.parse(_acidityController.text),
        dryMatter: double.parse(_dryMatterController.text),
        density: double.parse(_densityController.text),
        freezingPoint: double.parse(_freezingPointController.text),
        description: _descriptionController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('فروش شیر ثبت شد')));
        _clearForm();
        _fetchSales();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطا: $e')));
      }
    }
  }

  bool _validateInputs() {
    if (_weightController.text.isEmpty ||
        _fatPercentageController.text.isEmpty ||
        _waterPercentageController.text.isEmpty ||
        _proteinController.text.isEmpty ||
        _lactoseController.text.isEmpty ||
        _acidityController.text.isEmpty ||
        _dryMatterController.text.isEmpty ||
        _densityController.text.isEmpty ||
        _freezingPointController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً همه فیلدها را پر کنید')),
      );
      return false;
    }
    if (double.tryParse(_weightController.text) == null ||
        double.tryParse(_fatPercentageController.text) == null ||
        double.tryParse(_waterPercentageController.text) == null ||
        double.tryParse(_proteinController.text) == null ||
        double.tryParse(_lactoseController.text) == null ||
        double.tryParse(_acidityController.text) == null ||
        double.tryParse(_dryMatterController.text) == null ||
        double.tryParse(_densityController.text) == null ||
        double.tryParse(_freezingPointController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً مقادیر عددی وارد کنید')),
      );
      return false;
    }
    if (double.parse(_weightController.text) <= 0 ||
        double.parse(_fatPercentageController.text) < 0 ||
        double.parse(_waterPercentageController.text) < 0 ||
        double.parse(_proteinController.text) < 0 ||
        double.parse(_lactoseController.text) < 0 ||
        double.parse(_acidityController.text) < 0 ||
        double.parse(_dryMatterController.text) < 0 ||
        double.parse(_densityController.text) < 0 ||
        double.parse(_freezingPointController.text) < 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('مقادیر باید مثبت باشند')));
      return false;
    }
    return true;
  }

  void _clearForm() {
    _dateController.clear();
    _timeController.clear();
    _customerNameController.clear();
    _weightController.clear();
    _fatPercentageController.clear();
    _waterPercentageController.clear();
    _proteinController.clear();
    _lactoseController.clear();
    _acidityController.clear();
    _dryMatterController.clear();
    _densityController.clear();
    _freezingPointController.clear();
    _descriptionController.clear();
    setState(() => _customerImageUrl = '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('فروش شیر')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    'تاریخ',
                    _dateController,
                    TextInputType.datetime,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    'ساعت',
                    _timeController,
                    TextInputType.datetime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildDropdownField(),
            const SizedBox(height: 10),
            _buildCustomerImage(),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    'وزن (کیلوگرم)',
                    _weightController,
                    TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    'درصد چربی',
                    _fatPercentageController,
                    TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    'درصد آب',
                    _waterPercentageController,
                    TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    'پروتئین',
                    _proteinController,
                    TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    'لاکتوز',
                    _lactoseController,
                    TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    'اسیدیته',
                    _acidityController,
                    TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    'ماده خشک',
                    _dryMatterController,
                    TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    'دانسیته',
                    _densityController,
                    TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    'انجماد',
                    _freezingPointController,
                    TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildInputField(
              'توضیحات',
              _descriptionController,
              TextInputType.multiline,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _addSale, child: const Text('ثبت فروش')),
            const SizedBox(height: 20),
            _buildSaleList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    TextInputType inputType,
  ) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'نام مشتری',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items:
          ['مشتری 1', 'مشتری 2', 'مشتری 3']
              .map(
                (value) => DropdownMenuItem(value: value, child: Text(value)),
              )
              .toList(),
      onChanged: (value) async {
        if (value != null) {
          _customerNameController.text = value;
          try {
            final imageUrl = await _milkService.getCustomerImage(value);
            setState(() => _customerImageUrl = imageUrl);
          } catch (e) {
            ScaffoldMessenger.of(
              // ignore: use_build_context_synchronously
              context,
            ).showSnackBar(SnackBar(content: Text('خطا در دریافت عکس: $e')));
          }
        }
      },
    );
  }

  Widget _buildCustomerImage() {
    return Column(
      children: [
        if (_customerImageUrl.isNotEmpty)
          Image.network(_customerImageUrl, height: 100),
        if (_customerImageUrl.isEmpty) const Text('عکس مشتری موجود نیست'),
      ],
    );
  }

  Widget _buildSaleList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _sales.length,
      itemBuilder: (context, index) {
        final sale = _sales[index];
        return ListTile(
          title: Text(sale['customer_name']),
          subtitle: Text(
            'وزن: ${sale['weight']} کیلوگرم | چربی: ${sale['fat_percentage']}%',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editSale(index),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteSale(index),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editSale(int index) {
    final sale = _sales[index];
    _dateController.text = sale['date'];
    _timeController.text = sale['time'];
    _customerNameController.text = sale['customer_name'];
    _weightController.text = sale['weight'].toString();
    _fatPercentageController.text = sale['fat_percentage'].toString();
    _waterPercentageController.text = sale['water_percentage'].toString();
    _proteinController.text = sale['protein'].toString();
    _lactoseController.text = sale['lactose'].toString();
    _acidityController.text = sale['acidity'].toString();
    _dryMatterController.text = sale['dry_matter'].toString();
    _densityController.text = sale['density'].toString();
    _freezingPointController.text = sale['freezing_point'].toString();
    _descriptionController.text = sale['description'];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('ویرایش فروش'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildInputField(
                    'تاریخ',
                    _dateController,
                    TextInputType.datetime,
                  ),
                  _buildInputField(
                    'ساعت',
                    _timeController,
                    TextInputType.datetime,
                  ),
                  _buildDropdownField(),
                  _buildInputField(
                    'وزن (کیلوگرم)',
                    _weightController,
                    TextInputType.number,
                  ),
                  _buildInputField(
                    'درصد چربی',
                    _fatPercentageController,
                    TextInputType.number,
                  ),
                  _buildInputField(
                    'درصد آب',
                    _waterPercentageController,
                    TextInputType.number,
                  ),
                  _buildInputField(
                    'پروتئین',
                    _proteinController,
                    TextInputType.number,
                  ),
                  _buildInputField(
                    'لاکتوز',
                    _lactoseController,
                    TextInputType.number,
                  ),
                  _buildInputField(
                    'اسیدیته',
                    _acidityController,
                    TextInputType.number,
                  ),
                  _buildInputField(
                    'ماده خشک',
                    _dryMatterController,
                    TextInputType.number,
                  ),
                  _buildInputField(
                    'دانسیته',
                    _densityController,
                    TextInputType.number,
                  ),
                  _buildInputField(
                    'انجماد',
                    _freezingPointController,
                    TextInputType.number,
                  ),
                  _buildInputField(
                    'توضیحات',
                    _descriptionController,
                    TextInputType.multiline,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('لغو'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await _milkService.updateSale(
                      id: sale['id'],
                      date: _dateController.text,
                      time: _timeController.text,
                      customerName: _customerNameController.text,
                      weight: double.parse(_weightController.text),
                      fatPercentage: double.parse(
                        _fatPercentageController.text,
                      ),
                      waterPercentage: double.parse(
                        _waterPercentageController.text,
                      ),
                      protein: double.parse(_proteinController.text),
                      lactose: double.parse(_lactoseController.text),
                      acidity: double.parse(_acidityController.text),
                      dryMatter: double.parse(_dryMatterController.text),
                      density: double.parse(_densityController.text),
                      freezingPoint: double.parse(
                        _freezingPointController.text,
                      ),
                      description: _descriptionController.text,
                    );
                    if (mounted) {
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      _fetchSales();
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(
                        // ignore: use_build_context_synchronously
                        context,
                      ).showSnackBar(SnackBar(content: Text('خطا: $e')));
                    }
                  }
                },
                child: const Text('ذخیره'),
              ),
            ],
          ),
    );
  }

  void _deleteSale(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('حذف فروش'),
            content: const Text('آیا از حذف این فروش اطمینان دارید؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('لغو'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await _milkService.deleteSale(id: _sales[index]['id']);
                    if (mounted) {
                      setState(() => _sales.removeAt(index));
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(
                        // ignore: use_build_context_synchronously
                        context,
                      ).showSnackBar(SnackBar(content: Text('خطا: $e')));
                    }
                  }
                },
                child: const Text('حذف'),
              ),
            ],
          ),
    );
  }
}
