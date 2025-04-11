import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/crm_screen.dart';
import 'screens/milk_purchase_screen.dart';
import 'screens/milk_sales_screen.dart';
import 'screens/milk_reports_screen.dart';
import 'screens/add_user_screen.dart'; // صفحه ثبت کاربر جدید
import 'screens/edit_users_screen.dart'; // صفحه ویرایش کاربران
import 'screens/inventory/inventory_routes.dart'; // اضافه کردن ماژول انبار

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ERP 2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Vazir', // فونت پیشفرض برای کل اپلیکیشن
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa', 'IR'), // فارسی ایران
      ],
      locale: const Locale('fa', 'IR'),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/milk_purchase_screen': (context) => const MilkPurchaseScreen(),
        '/milk_sale_screen': (context) => const MilkSaleScreen(),
        '/milk_reports_screen': (context) => const MilkReportScreen(),
        '/add_user': (context) => const AddUserScreen(), // صفحه ثبت کاربر جدید
        '/edit_users':
            (context) => const EditUsersScreen(), // صفحه ویرایش کاربران
        '/crm': (context) => const CrmScreen(),
        ...InventoryRoutes.getRoutes(), // اضافه کردن مسیرهای انبار
      },
    );
  }
}
