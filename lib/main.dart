import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro/widgets/translations.dart';
import 'Signup.dart';
import 'LoginScreen.dart';
import 'ForgotPasswordScreen.dart'; // تضمين صفحة استعادة كلمة المرور
import 'controller/usercontroller.dart';
import 'store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final userController = Get.put(UserController());
  await userController.checkLoginStatus();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Messages(),
      locale: Locale('en', 'US'),
      fallbackLocale: Locale('en', 'US'),
      title: 'Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialBinding: BindingsBuilder(() {
        Get.lazyPut<UserController>(() => UserController());
      }),
      initialRoute: Get.find<UserController>().isLoggedIn() ? '/store' : '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => Directionality(
            textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            child: LoginScreen(),
          ),
        ),
        GetPage(
          name: '/signup',
          page: () => Directionality(
            textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            child: SignupPage(),
          ),
        ),
        GetPage(
          name: '/forgot_password',
          page: () => Directionality(
            textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            child: ForgotPasswordScreen(),
          ),
        ),
        GetPage(
          name: '/store',
          page: () => Directionality(
            textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            child: Store(),
          ),
        ),
      ],
    );
  }
}

