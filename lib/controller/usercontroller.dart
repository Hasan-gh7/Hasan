import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:pro/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class UserController extends GetxController {
  // متحكمات خاصة بالتسجيل
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final signupPhoneNumberController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final locationController = TextEditingController();

  // متحكمات خاصة بتسجيل الدخول
  final loginPhoneNumberController = TextEditingController();
  final loginPasswordController = TextEditingController();

  bool _isLoggedIn = false;

  var saveLoginInfo = false.obs; // متغير لتحديد حالة AnimatedSwitch
  var profilePic = Rx<XFile?>(null); // متغير لتخزين صورة الملف الشخصي

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    signupPhoneNumberController.dispose();
    signupPasswordController.dispose();
    locationController.dispose();
    loginPhoneNumberController.dispose();
    loginPasswordController.dispose();
    super.dispose();
  }

  Future<void> signup(BuildContext context) async {
    if (firstNameController.text.isEmpty || lastNameController.text.isEmpty || signupPhoneNumberController.text.isEmpty || signupPasswordController.text.isEmpty || locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all the fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    File? profileImageFile = profilePic.value != null ? File(profilePic.value!.path) : null;

    final response = await HttpService.signup(
      firstNameController.text,
      lastNameController.text,
      signupPhoneNumberController.text,
      signupPasswordController.text,
      locationController.text,
      profileImageFile,
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      // حفظ الرمز في SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User registered successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to register user: ${response.body}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        Get.snackbar('تنبيه', 'خدمات الموقع غير مفعلة. يرجى تفعيلها لاستخدام هذه الميزة.');
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        Get.snackbar('تنبيه', 'تم رفض إذن الوصول إلى الموقع. يرجى السماح باستخدام خدمات الموقع.');
        return;
      }
    }

    // احصل على الموقع الحالي بعد التأكد من تفعيل الخدمات ومنح الأذن
    _locationData = await location.getLocation();
    locationController.text = 'Lat: ${_locationData.latitude}, Long: ${_locationData.longitude}';
    Get.snackbar('تم الحصول على الموقع', 'تم استرجاع موقعك بنجاح.');
  }

  Future<bool> login(BuildContext context) async {
    try {
      final response = await HttpService.login(
        loginPhoneNumberController.text,
        loginPasswordController.text,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        // حفظ الرمز في SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login successful'),
            backgroundColor: Colors.green,
          ),
        );

        if (saveLoginInfo.value) {
          // حفظ معلومات تسجيل الدخول
          await prefs.setString('phoneNumber', loginPhoneNumberController.text);
          await prefs.setString('password', loginPasswordController.text);
        }
        _isLoggedIn = true;

        // إضافة تأخير قبل التوجيه إلى صفحة Store
        await Future.delayed(Duration(seconds: 2)); // تأخير لمدة ثانيتين
        Get.offAllNamed('/store');
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  Future<void> forgotPassword(BuildContext context) async {
    try {
      final response = await HttpService.checkAccount(loginPhoneNumberController.text);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['user'] != null && (data['user']['email'] == null || data['user']['email'].isEmpty)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Email not found. Please enter your email address.'),
              backgroundColor: Colors.yellow,
            ),
          );
          // إظهار حقل البريد الإلكتروني
          Get.toNamed('/update_email');
        } else if (data['user'] != null) {
          // إذا كان هناك بريد إلكتروني، إرسال رمز التحقق
          await HttpService.sendPasswordResetPhone(loginPhoneNumberController.text);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Reset token sent successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account not found: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // التحقق من تسجيل الدخول تلقائيًا عند بدء التطبيق
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final phoneNumber = prefs.getString('phoneNumber') ?? '';
    final password = prefs.getString('password') ?? '';

    if (phoneNumber.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      // ملء الحقول تلقائيًا إذا كانت البيانات موجودة
      loginPhoneNumberController.text = phoneNumber;
      loginPasswordController.text = password;
    } else {
      _isLoggedIn = false;
    }
  }

  bool isLoggedIn() {
    return _isLoggedIn;
  }

  // تسجيل الخروج
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('phoneNumber');
    await prefs.remove('password');
    await prefs.remove('token'); // إزالة الرمز عند تسجيل الخروج
    _isLoggedIn = false;

    // إعادة التوجيه إلى صفحة تسجيل الدخول
    Get.offAllNamed('/login');
  }

  Future<void> uploadProfilePic(XFile file) async {
    profilePic.value = file;
    update();
  }

  // إعادة تعيين قيم المتحكمات
  void resetSignupControllers() {
    firstNameController.clear();
    lastNameController.clear();
    signupPhoneNumberController.clear();
    signupPasswordController.clear();
    locationController.clear();
  }

  void resetLoginControllers() {
    loginPhoneNumberController.clear();
    loginPasswordController.clear();
  }
}
