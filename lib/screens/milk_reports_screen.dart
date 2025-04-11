import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:erp_2/services/milk_service.dart';
import 'package:logger/logger.dart';

class MilkReportScreen extends StatefulWidget {
  const MilkReportScreen({super.key});

  @override
  MilkReportsScreenState createState() => MilkReportsScreenState();
}

class MilkReportsScreenState extends State<MilkReportScreen> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final MilkService _milkService = MilkService();
  List<dynamic> _purchases = [];
  List<dynamic> _sales = [];
  double _totalPurchaseWeight = 0;
  double _totalSaleWeight = 0;
  double _averageFatPurchase = 0;
  double _averageFatSale = 0;
  double _averageWaterPurchase = 0;
  double _averageWaterSale = 0;
  String _selectedReportType = 'گزارش کلی';
  final List<String> _selectedParameters = [];
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _setDateTime();
    _fetchData();
  }

  void _setDateTime() {
    final now = DateTime.now();
    final oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
    _startDateController.text = DateFormat('yyyy-MM-dd').format(oneMonthAgo);
    _endDateController.text = DateFormat('yyyy-MM-dd').format(now);
  }

  Future<void> _fetchData() async {
    try {
      final purchases = await _milkService.fetchPurchases();
      final sales = await _milkService.fetchSales();
      if (mounted) {
        setState(() {
          _purchases = purchases;
          _sales = sales;
          _calculateStatistics();
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

  void _calculateStatistics() {
    _totalPurchaseWeight = _purchases.fold(
      0.0,
      (sum, purchase) => sum + (purchase['weight'] ?? 0),
    );
    _totalSaleWeight = _sales.fold(
      0.0,
      (sum, sale) => sum + (sale['weight'] ?? 0),
    );

    final totalFatPurchase = _purchases.fold(
      0.0,
      (sum, purchase) => sum + (purchase['fat_percentage'] ?? 0),
    );
    _averageFatPurchase =
        _purchases.isNotEmpty ? totalFatPurchase / _purchases.length : 0;

    final totalFatSale = _sales.fold(
      0.0,
      (sum, sale) => sum + (sale['fat_percentage'] ?? 0),
    );
    _averageFatSale = _sales.isNotEmpty ? totalFatSale / _sales.length : 0;

    final totalWaterPurchase = _purchases.fold(
      0.0,
      (sum, purchase) => sum + (purchase['water_percentage'] ?? 0),
    );
    _averageWaterPurchase =
        _purchases.isNotEmpty ? totalWaterPurchase / _purchases.length : 0;

    final totalWaterSale = _sales.fold(
      0.0,
      (sum, sale) => sum + (sale['water_percentage'] ?? 0),
    );
    _averageWaterSale = _sales.isNotEmpty ? totalWaterSale / _sales.length : 0;
  }

  Future<void> _filterData() async {
    try {
      final startDate = _startDateController.text;
      final endDate = _endDateController.text;
      final purchases = await _milkService.fetchPurchasesByDate(
        startDate,
        endDate,
      );
      final sales = await _milkService.fetchSalesByDate(startDate, endDate);
      if (mounted) {
        setState(() {
          _purchases = purchases;
          _sales = sales;
          _calculateStatistics();
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

  
void _exportToExcel() async {
  final workbook = Workbook();
  final sheet = workbook.worksheets[0];
  
  // ستون‌ها
  sheet.getRangeByName('A1').setText('تاریخ');
  sheet.getRangeByName('B1').setText('نوع');
  sheet.getRangeByName('C1').setText('وزن');
  sheet.getRangeByName('D1').setText('چربی');
  sheet.getRangeByName('E1').setText('آب');

  // داده‌ها
  int rowIndex = 2;
  for (var purchase in _purchases) {
    sheet.getRangeByIndex(rowIndex, 1).setText(purchase['date'].toString());
    sheet.getRangeByIndex(rowIndex, 2).setText('خرید');
    sheet.getRangeByIndex(rowIndex, 3).setNumber(purchase['weight']);
    sheet.getRangeByIndex(rowIndex, 4).setNumber(purchase['fat_percentage']);
    sheet.getRangeByIndex(rowIndex, 5).setNumber(purchase['water_percentage']);
    rowIndex++;
  }
  for (var sale in _sales) {
    sheet.getRangeByIndex(rowIndex, 1).setText(sale['date'].toString());
    sheet.getRangeByIndex(rowIndex, 2).setText('فروش');
    sheet.getRangeByIndex(rowIndex, 3).setNumber(sale['weight']);
    sheet.getRangeByIndex(rowIndex, 4).setNumber(sale['fat_percentage']);
    sheet.getRangeByIndex(rowIndex, 5).setNumber(sale['water_percentage']);
    rowIndex++;
  }

  // ذخیره فایل
  final bytes = workbook.saveAsStream();
  workbook.dispose();
  final file = File('report.xlsx');
  await file.writeAsBytes(bytes);
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('گزارش با موفقیت ذخیره شد')),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ), // اضافه کردن پرانتز بسته
      ), // اضافه کردن پرانتز بسته
    );
  }

  Widget _buildStatisticRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final bars = [
      BarChartGroupData(
        x: 0,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: _totalPurchaseWeight,
            color: Colors.blue,
            width: 20,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: _totalSaleWeight,
            color: Colors.green,
            width: 20,
          ),
        ],
      ),
    ];

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: bars,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text('خرید', style: TextStyle(fontSize: 12));
                    case 1:
                      return const Text('فروش', style: TextStyle(fontSize: 12));
                    default:
                      return const Text('');
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
        ),
      ),
    );
  }

  Widget _buildPurchaseAndSaleList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'لیست خریدها',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildList(_purchases, 'farmer_name'),
        const SizedBox(height: 20),
        const Text(
          'لیست فروش‌ها',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildList(_sales, 'customer_name'),
      ],
    );
  }

  Widget _buildList(List<dynamic> items, String nameKey) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item[nameKey].toString()),
          subtitle: Text(
            'وزن: ${item['weight']} کیلوگرم | چربی: ${item['fat_percentage']}%',
          ),
        );
      },
    );
  }

  Widget _buildReportMenu() {
    return DropdownButton<String>(
      value: _selectedReportType,
      items: [
        DropdownMenuItem(value: 'گزارش کلی', child: Text('گزارش کلی')),
        DropdownMenuItem(
          value: 'گزارش روزانه خرید',
          child: Text('گزارش روزانه خرید'),
        ),
        DropdownMenuItem(
          value: 'گزارش روزانه فروش',
          child: Text('گزارش روزانه فروش'),
        ),
        DropdownMenuItem(value: 'گزارش سفارشی', child: Text('گزارش سفارشی')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedReportType = value!;
        });
      },
    );
  }

  Widget _buildCustomReportForm() {
    return Column(
      children: [
        CheckboxListTile(
          title: Text('چربی'),
          value: _selectedParameters.contains('fat_percentage'),
          onChanged: (value) {
            setState(() {
              if (value!) {
                _selectedParameters.add('fat_percentage');
              } else {
                _selectedParameters.remove('fat_percentage');
              }
            });
          },
        ),
        CheckboxListTile(
          title: Text('آب'),
          value: _selectedParameters.contains('water_percentage'),
          onChanged: (value) {
            setState(() {
              if (value!) {
                _selectedParameters.add('water_percentage');
              } else {
                _selectedParameters.remove('water_percentage');
              }
            });
          },
        ),
        ElevatedButton(
          onPressed: _generateCustomReport,
          child: Text('تولید گزارش'),
        ),
      ],
    );
  }

  void _generateCustomReport() {
    logger.i('پارامترهای انتخاب‌شده: $_selectedParameters');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('گزارش‌های شیر'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportToExcel,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    'تاریخ شروع',
                    _startDateController,
                    TextInputType.datetime,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    'تاریخ پایان',
                    _endDateController,
                    TextInputType.datetime,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _filterData,
                  child: const Text('اعمال فیلتر'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildReportMenu(),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildStatisticRow(
                      'مجموع وزن خریدها',
                      '${_totalPurchaseWeight.toStringAsFixed(2)} کیلوگرم',
                    ),
                    _buildStatisticRow(
                      'مجموع وزن فروش‌ها',
                      '${_totalSaleWeight.toStringAsFixed(2)} کیلوگرم',
                    ),
                    _buildStatisticRow(
                      'میانگین چربی خرید',
                      '${_averageFatPurchase.toStringAsFixed(2)}%',
                    ),
                    _buildStatisticRow(
                      'میانگین چربی فروش',
                      '${_averageFatSale.toStringAsFixed(2)}%',
                    ),
                    _buildStatisticRow(
                      'میانگین درصد آب خرید',
                      '${_averageWaterPurchase.toStringAsFixed(2)}%',
                    ),
                    _buildStatisticRow(
                      'میانگین درصد آب فروش',
                      '${_averageWaterSale.toStringAsFixed(2)}%',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildChart(),
            const SizedBox(height: 20),
            _buildCustomReportForm(),
            const SizedBox(height: 20),
            _buildPurchaseAndSaleList(),
          ],
        ),
      ),
    );
  }
}
