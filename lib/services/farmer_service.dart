import 'dart:io';
import 'package:erp_2/services/database_service.dart';

class FarmerService {
  final DatabaseService _databaseService = DatabaseService();

  Future<void> initialize() async {
    await _databaseService.connect();
  }

  Future<void> dispose() async {
    await _databaseService.close();
  }

  // دریافت لیست دامداران
  Future<List<Map<String, dynamic>>> fetchFarmers() async {
    return await _databaseService.query('SELECT * FROM farmers');
  }

  // افزودن دامدار جدید
  Future<void> addFarmer({
    required String name,
    required String fatherName,
    required String address,
    required String postalCode,
    required String phone,
    required String smsPhone,
    required String description,
    required bool isActive,
    File? image,
  }) async {
    final imageBytes = image != null ? await image.readAsBytes() : null;
    await _databaseService.execute(
      '''
      INSERT INTO farmers (
        name, father_name, address, postal_code, phone, sms_phone, description, is_active, image
      ) VALUES (@name, @fatherName, @address, @postalCode, @phone, @smsPhone, @description, @isActive, @image)
      ''',
      {
        'name': name,
        'fatherName': fatherName,
        'address': address,
        'postalCode': postalCode,
        'phone': phone,
        'smsPhone': smsPhone,
        'description': description,
        'isActive': isActive,
        'image': imageBytes,
      },
    );
  }

  // به‌روزرسانی وضعیت دامدار
  Future<void> updateFarmerStatus(int farmerId, bool isActive) async {
    await _databaseService.execute(
      'UPDATE farmers SET is_active = @isActive WHERE id = @farmerId',
      {'isActive': isActive, 'farmerId': farmerId},
    );
  }

  // آپلود تصویر دامدار
  Future<void> uploadFarmerImage(int farmerId, File image) async {
    final imageBytes = await image.readAsBytes();
    await _databaseService.execute(
      'UPDATE farmers SET image = @image WHERE id = @farmerId',
      {'image': imageBytes, 'farmerId': farmerId},
    );
  }
}
