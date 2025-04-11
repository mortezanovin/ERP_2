import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:erp_2/services/farmer_service.dart';

class CrmScreen extends StatefulWidget {
  const CrmScreen({super.key});

  @override
  CrmScreenState createState() => CrmScreenState();
}

class CrmScreenState extends State<CrmScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _farmers = [];
  List<dynamic> _filteredFarmers = [];
  File? _image;
  final FarmerService _farmerService = FarmerService();

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await _farmerService.initialize();
    _fetchFarmers();
  }

  @override
  void dispose() {
    _farmerService.dispose();
    super.dispose();
  }

  Future<void> _fetchFarmers() async {
    try {
      final farmers = await _farmerService.fetchFarmers();
      if (mounted) {
        setState(() {
          _farmers = farmers;
          _filteredFarmers = farmers;
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

  void _searchFarmers(String query) {
    setState(() {
      _filteredFarmers =
          _farmers.where((farmer) {
            final nationalCode = farmer['national_code'].toString();
            final phone = farmer['phone'].toString();
            return nationalCode.contains(query) || phone.contains(query);
          }).toList();
    });
  }

  Future<void> _addFarmer(Map<String, dynamic> farmerData) async {
    try {
      await _farmerService.addFarmer(
        name: farmerData['name'],
        fatherName: farmerData['father_name'],
        address: farmerData['address'],
        postalCode: farmerData['postal_code'],
        phone: farmerData['phone'],
        smsPhone: farmerData['sms_phone'],
        description: farmerData['description'],
        isActive: farmerData['is_active'],
        image: _image,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('دامدار اضافه شد')));
        _fetchFarmers(); // به‌روزرسانی لیست
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطا: $e')));
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage(int farmerId) async {
    if (_image == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('لطفاً عکسی انتخاب کنید')));
      }
      return;
    }
    try {
      await _farmerService.uploadFarmerImage(farmerId, _image!);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('عکس با موفقیت آپلود شد')));
        _fetchFarmers(); // به‌روزرسانی لیست
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطا: $e')));
      }
    } finally {
      setState(() {
        _image = null; // پاک کردن عکس انتخاب‌شده
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مدیریت مشتریان (CRM)')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'جستجو',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchFarmers(_searchController.text);
                  },
                ),
              ),
              onChanged: (value) {
                _searchFarmers(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredFarmers.length,
              itemBuilder: (context, index) {
                final farmer = _filteredFarmers[index];
                return ListTile(
                  leading:
                      farmer['image'] != null
                          ? CircleAvatar(
                            backgroundImage: MemoryImage(farmer['image']),
                          )
                          : const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(farmer['name']),
                  subtitle: Text('کد ملی: ${farmer['national_code']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.image),
                        onPressed: () async {
                          await _pickImage();
                          if (_image != null) {
                            await _uploadImage(farmer['id']);
                          }
                        },
                      ),
                      Switch(
                        value: farmer['is_active'],
                        onChanged: (value) async {
                          try {
                            await _farmerService.updateFarmerStatus(
                              farmer['id'],
                              value,
                            );
                            if (mounted) {
                              _fetchFarmers(); // به‌روزرسانی لیست
                            }
                          } catch (e) {
                            if (mounted) {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('خطا: $e')),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddFarmerDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddFarmerDialog() {
    final nameController = TextEditingController();
    final fatherNameController = TextEditingController();
    final addressController = TextEditingController();
    final postalCodeController = TextEditingController();
    final phoneController = TextEditingController();
    final smsPhoneController = TextEditingController();
    final descriptionController = TextEditingController();
    bool isActive = true;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('افزودن دامدار'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'نام و نام خانوادگی',
                  ),
                ),
                TextField(
                  controller: fatherNameController,
                  decoration: const InputDecoration(labelText: 'نام پدر'),
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'آدرس'),
                ),
                TextField(
                  controller: postalCodeController,
                  decoration: const InputDecoration(labelText: 'کد پستی'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'شماره تماس'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: smsPhoneController,
                  decoration: const InputDecoration(labelText: 'شماره پیامک'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'توضیحات'),
                  maxLines: 3,
                ),
                Row(
                  children: [
                    const Text('فعال:'),
                    Switch(
                      value: isActive,
                      onChanged: (value) {
                        setState(() {
                          isActive = value;
                        });
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('بارگذاری عکس'),
                ),
                if (_image != null) Image.file(_image!, height: 100),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('لغو'),
            ),
            TextButton(
              onPressed: () async {
                final farmerData = {
                  'name': nameController.text,
                  'father_name': fatherNameController.text,
                  'address': addressController.text,
                  'postal_code': postalCodeController.text,
                  'phone': phoneController.text,
                  'sms_phone': smsPhoneController.text,
                  'description': descriptionController.text,
                  'is_active': isActive,
                };
                await _addFarmer(farmerData);
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
              },
              child: const Text('ذخیره'),
            ),
          ],
        );
      },
    );
  }
}
