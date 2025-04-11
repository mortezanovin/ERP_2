import 'package:flutter/material.dart';
import 'package:erp_2/screens/milk_purchase_screen.dart'; // صفحه خرید شیر
import 'package:erp_2/screens/milk_sales_screen.dart'; // صفحه فروش شیر
import 'package:erp_2/screens/milk_reports_screen.dart'; // صفحه گزارشات

class MilkDashboardScreen extends StatelessWidget {
  const MilkDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('سکو شیر'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDashboardButton(
              context,
              'خرید شیر',
              Icons.shopping_cart,
              const MilkPurchaseScreen(),
            ),
            const SizedBox(height: 20),
            _buildDashboardButton(
              context,
              'فروش شیر',
              Icons.sell,
              const MilkSaleScreen(),
            ),
            const SizedBox(height: 20),
            _buildDashboardButton(
              context,
              'گزارشات',
              Icons.bar_chart,
              const MilkReportScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton(
    BuildContext context,
    String label,
    IconData icon,
    Widget screen,
  ) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      icon: Icon(icon, size: 24),
      label: Text(label, style: const TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
    );
  }
}
