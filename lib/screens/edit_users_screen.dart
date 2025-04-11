import 'package:flutter/material.dart';
import 'package:erp_2/models/user_model.dart';
import 'package:erp_2/services/user_service.dart';

class EditUsersScreen extends StatefulWidget {
  const EditUsersScreen({super.key});

  @override
  EditUsersScreenState createState() => EditUsersScreenState();
}

class EditUsersScreenState extends State<EditUsersScreen> {
  final UserService _userService = UserService();
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final users = await _userService.fetchUsers();
      if (mounted) {
        setState(() {
          _users = users;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ویرایش کاربران')),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return ListTile(
            title: Text(user.username),
            subtitle: Text(user.email),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // عملیات ویرایش
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    try {
                      await _userService.deleteUser(user.id);
                      if (mounted) {
                        _fetchUsers(); // به‌روزرسانی لیست
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
