import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class HttpService {
  static const String baseUrl = 'https://3bea-185-107-56-104.ngrok-free.app/api/';

  // دالة التسجيل
  static Future<http.Response> signup(String firstName, String lastName, String phoneNumber, String password, String location, File? profileImage) async {
    try {
      var uri = Uri.parse('${baseUrl}register');
      var request = http.MultipartRequest('POST', uri);
      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;
      request.fields['phone_number'] = phoneNumber;
      request.fields['password'] = password;
      request.fields['location'] = location;

      if (profileImage != null) {
        var pic = await http.MultipartFile.fromPath('profile_image', profileImage.path);
        request.files.add(pic);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return response;
      } else {
        throw Exception('Failed to register user: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred during signup: $e');
    }
  }

  // دالة تسجيل الدخول
  static Future<http.Response> login(String phoneNumber, String password) async {
    try {
      if (phoneNumber.isEmpty || password.isEmpty) {
        throw Exception('Phone number and password cannot be empty');
      }

      final response = await http.post(
        Uri.parse('${baseUrl}login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phone_number': phoneNumber,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred during login: $e');
    }
  }

  // دالة التحقق من الحساب
  static Future<http.Response> checkAccount(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}check_account'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phone_number': phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to check account: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred during account check: $e');
    }
  }

  // دالة تحديث البريد الإلكتروني
  static Future<http.Response> updateEmail(String phoneNumber, String email) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}update_email'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phone_number': phoneNumber,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to update email: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred during email update: $e');
    }
  }

  // دالة إرسال رمز استعادة كلمة المرور
  static Future<http.Response> sendPasswordResetPhone(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}forgot_password'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phone_number': phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to send reset token: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred during password reset: $e');
    }
  }
}
