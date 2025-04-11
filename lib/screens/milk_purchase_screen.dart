import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:erp_2/services/milk_service.dart';

class MilkPurchaseScreen extends StatefulWidget {
  const MilkPurchaseScreen({super.key});

  @override
  MilkPurchaseScreenState createState() => MilkPurchaseScreenState();
}

class MilkPurchaseScreenState extends State<MilkPurchaseScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _farmerNameController = TextEditingController();
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
  List<dynamic> _purchases = [];
  String _farmerImageUrl = ''; // برای ذخیره آدرس عکس دامدار

  @override
  void initState() {
    super.initState();
    _fetchPurchases();
    _setDateTime();
  }

  void _setDateTime() {
    final now = DateTime.now();
    _dateController.text = DateFormat('yyyy-MM-dd').format(now);
    _timeController.text = DateFormat('HH:mm').format(now);
  }

  Future<void> _fetchPurchases() async {
    try {
      final purchases = await _milkService.fetchPurchases();
      if (mounted) setState(() => _purchases = purchases);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطا: $e')));
      }
    }
  }

  Future<void> _addPurchase() async {
    if (!_validateInputs()) return;
    try {
      await _milkService.addPurchase(
        date: _dateController.text,
        time: _timeController.text,
        farmerName: _farmerNameController.text,
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
        ).showSnackBar(const SnackBar(content: Text('خرید شیر ثبت شد')));
        _clearForm();
        _fetchPurchases();
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
    _farmerNameController.clear();
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
    setState(() => _farmerImageUrl = '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('خرید شیر')),
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
            _buildFarmerImage(),
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
            ElevatedButton(
              onPressed: _addPurchase,
              child: const Text('ثبت خرید'),
            ),
            const SizedBox(height: 20),
            _buildPurchaseList(),
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
        labelText: 'نام دامدار',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items:
          ['دامدار 1', 'دامدار 2', 'دامدار 3']
              .map(
                (value) => DropdownMenuItem(value: value, child: Text(value)),
              )
              .toList(),
      onChanged: (value) async {
        if (value != null) {
          _farmerNameController.text = value;
          try {
            final imageUrl = await _milkService.getFarmerImage(value);
            setState(() {
              _farmerImageUrl = imageUrl; // ذخیره آدرس عکس
            });
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

  Widget _buildFarmerImage() {
    return Column(
      children: [
        if (_farmerImageUrl.isNotEmpty)
          Image.network(_farmerImageUrl, height: 100), // نمایش عکس از URL
        if (_farmerImageUrl.isEmpty) const Text('عکس دامدار موجود نیست'),
      ],
    );
  }

  Widget _buildPurchaseList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _purchases.length,
      itemBuilder: (context, index) {
        final purchase = _purchases[index];
        return ListTile(
          title: Text(purchase['farmer_name']),
          subtitle: Text(
            'وزن: ${purchase['weight']} کیلوگرم | چربی: ${purchase['fat_percentage']}%',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editPurchase(index),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deletePurchase(index),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editPurchase(int index) {
    final purchase = _purchases[index];
    _dateController.text = purchase['date'];
    _timeController.text = purchase['time'];
    _farmerNameController.text = purchase['farmer_name'];
    _weightController.text = purchase['weight'].toString();
    _fatPercentageController.text = purchase['fat_percentage'].toString();
    _waterPercentageController.text = purchase['water_percentage'].toString();
    _proteinController.text = purchase['protein'].toString();
    _lactoseController.text = purchase['lactose'].toString();
    _acidityController.text = purchase['acidity'].toString();
    _dryMatterController.text = purchase['dry_matter'].toString();
    _densityController.text = purchase['density'].toString();
    _freezingPointController.text = purchase['freezing_point'].toString();
    _descriptionController.text = purchase['description'];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('ویرایش خرید'),
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
                    await _milkService.updatePurchase(
                      id: purchase['id'],
                      date: _dateController.text,
                      time: _timeController.text,
                      farmerName: _farmerNameController.text,
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
                      _fetchPurchases();
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

  void _deletePurchase(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('حذف خرید'),
            content: const Text('آیا از حذف این خرید اطمینان دارید؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('لغو'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await _milkService.deletePurchase(
                      id: _purchases[index]['id'],
                    );
                    if (mounted) {
                      setState(() => _purchases.removeAt(index));
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
