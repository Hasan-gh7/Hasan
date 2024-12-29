import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pro/http.dart'; // تأكد من استيراد HttpService

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _message = '';
  bool _showEmailField = false;

  Future<void> _sendResetCode() async {
    try {
      final response = await HttpService.checkAccount(_phoneNumberController.text);

      final responseJson = jsonDecode(response.body);

      setState(() {
        if (response.statusCode == 200) {
          // إذا كان الحساب موجودًا، تحقق من البريد الإلكتروني
          if (responseJson['user'] != null && (responseJson['user']['email'] == null || responseJson['user']['email'].isEmpty)) {
            // إذا لم يكن هناك بريد إلكتروني، طلب البريد الإلكتروني من المستخدم
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Email not found. Please enter your email address.'),
                backgroundColor: Colors.yellow,
              ),
            );
            // استخدم setState لإظهار حقل البريد الإلكتروني
            _showEmailField = true; // تأكد من أن showEmailField موجود في StatefulWidget
          } else if (responseJson['user'] != null) {
            // إذا كان هناك بريد إلكتروني، إرسال رمز التحقق
            HttpService.sendPasswordResetPhone(_phoneNumberController.text);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Reset token sent successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          _message = responseJson['message'];
          _showEmailField = false;
        }
      });
    } catch (e) {
      setState(() {
        _message = 'An error occurred: $e';
      });
    }
  }

  Future<void> _updateEmailAndSendResetCode() async {
    try {
      final response = await HttpService.updateEmail(_phoneNumberController.text, _emailController.text);

      final responseJson = jsonDecode(response.body);

      setState(() {
        _message = responseJson['message'];
        _showEmailField = false;
      });

      if (response.statusCode == 200) {
        _sendResetCode();
      }
    } catch (e) {
      setState(() {
        _message = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            if (_showEmailField)
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _showEmailField ? _updateEmailAndSendResetCode : _sendResetCode,
              child: Text(_showEmailField ? 'Update Email & Send Code' : 'Send Reset Code'),
            ),
            SizedBox(height: 16.0),
            Text(_message),
          ],
        ),
      ),
    );
  }
}
