import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('صفحه اصلی')),
        actions: [
          IconButton(
            // دکمه خروج در سمت راست
            icon: const Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'شرکت تعاونی دهکده شیردانه مرودشت',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            // ماژول سکو شیر
            ExpansionTile(
              leading: const Icon(Icons.local_drink, color: Colors.blue),
              title: const Text('سکو شیر'),
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.add_shopping_cart,
                    color: Colors.green,
                  ),
                  title: const Text('خرید شیر'),
                  onTap: () {
                    Navigator.pushNamed(context, '/milk_purchase_screen');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.shopping_cart_checkout,
                    color: Colors.red,
                  ),
                  title: const Text('فروش شیر'),
                  onTap: () {
                    Navigator.pushNamed(context, '/milk_sale_screen');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bar_chart, color: Colors.orange),
                  title: const Text('گزارشات شیر'),
                  onTap: () {
                    Navigator.pushNamed(context, '/milk_reports_screen');
                  },
                ),
              ],
            ),
            // ماژول بازرگانی خرید و فروش
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.blue),
              title: const Text('بازرگانی خرید و فروش'),
              onTap: () {
                Navigator.pushNamed(context, '/trade_management');
              },
            ),
            // ماژول انبار
            ExpansionTile(
              leading: const Icon(Icons.warehouse, color: Colors.blue),
              title: const Text('انبار'),
              children: [
                ListTile(
                  leading: const Icon(Icons.list, color: Colors.green),
                  title: const Text('لیست کالاها'),
                  onTap: () {
                    Navigator.pushNamed(context, '/inventory');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add, color: Colors.green),
                  title: const Text('افزودن کالا'),
                  onTap: () {
                    Navigator.pushNamed(context, '/inventory/add');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.swap_horiz, color: Colors.orange),
                  title: const Text('انتقال کالا'),
                  onTap: () {
                    Navigator.pushNamed(context, '/inventory/transfer');
                  },
                ),
              ],
            ),
            // ماژول بارکود
            ListTile(
              leading: const Icon(Icons.qr_code, color: Colors.blue),
              title: const Text('باسکول'),
              onTap: () {
                Navigator.pushNamed(context, '/scale');
              },
            ),
            // ماژول تولید
            ListTile(
              leading: const Icon(Icons.factory, color: Colors.blue),
              title: const Text('تولید'),
              onTap: () {
                Navigator.pushNamed(context, '/production');
              },
            ),
            // ماژول قرارداد
            ListTile(
              leading: const Icon(Icons.assignment, color: Colors.blue),
              title: const Text('قرارداد'),
              onTap: () {
                Navigator.pushNamed(context, '/contracts');
              },
            ),
            // ماژول قیمت‌گذاری
            ListTile(
              leading: const Icon(Icons.attach_money, color: Colors.blue),
              title: const Text('قیمت‌گذاری'),
              onTap: () {
                Navigator.pushNamed(context, '/pricing');
              },
            ),
            // ماژول مدیریت کاربران
            ExpansionTile(
              leading: const Icon(Icons.people, color: Colors.blue),
              title: const Text('مدیریت کاربران'),
              children: [
                ListTile(
                  leading: const Icon(Icons.add, color: Colors.green),
                  title: const Text('ثبت کاربر جدید'),
                  onTap: () {
                    Navigator.pushNamed(context, '/add_user');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.orange),
                  title: const Text('ویرایش کاربران'),
                  onTap: () {
                    Navigator.pushNamed(context, '/edit_users');
                  },
                ),
              ],
            ),
            // ماژول مالی
            ListTile(
              leading: const Icon(Icons.account_balance, color: Colors.blue),
              title: const Text('مالی'),
              onTap: () {
                Navigator.pushNamed(context, '/financial_management');
              },
            ),
            // ماژول منابع انسانی
            ListTile(
              leading: const Icon(Icons.person_pin, color: Colors.blue),
              title: const Text('منابع انسانی'),
              onTap: () {
                Navigator.pushNamed(context, '/human_resources');
              },
            ),
            // ماژول گزارشات و داشبورد
            ListTile(
              leading: const Icon(Icons.bar_chart, color: Colors.blue),
              title: const Text('گزارشات و داشبورد'),
              onTap: () {
                Navigator.pushNamed(context, '/reports');
              },
            ),
            // ماژول تعمیرات و نگهداری
            ListTile(
              leading: const Icon(Icons.build, color: Colors.blue),
              title: const Text('تعمیرات و نگهداری'),
              onTap: () {
                Navigator.pushNamed(context, '/maintenance');
              },
            ),
            // ماژول مدیریت مشتریان (CRM)
            ListTile(
              leading: const Icon(Icons.contacts, color: Colors.blue),
              title: const Text('مدیریت مشتریان (CRM)'),
              onTap: () {
                Navigator.pushNamed(context, '/crm');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 220),
              const SizedBox(height: 20),
              const Text(
                'به سیستم یکپارچه شرکت تعاونی دهکده شیردانه مرودشت خوش آمدید',
                style: TextStyle(fontSize: 24, fontFamily: 'Vazir'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('خروج از حساب'),
            content: const Text(
              'آیا مطمئن هستید که می‌خواهید از حساب خود خارج شوید؟',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('لغو'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('بله'),
              ),
            ],
          ),
    );
  }
}
