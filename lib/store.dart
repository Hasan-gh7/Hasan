import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro/controller/usercontroller.dart';


class Store extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

 Store({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to the Store!'),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                userController.logout(context); // Perform logout
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
