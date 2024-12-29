import 'package:animated_switch/animated_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro/controller/usercontroller.dart';
import 'package:pro/widgets/textfield.dart'; // تضمين ملف CustomInputField

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UserController userController = Get.put(UserController());
  
  bool _isLoading = false; // متغير لتتبع حالة التحميل

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    bool loginSuccess = await userController.login(context);
    setState(() {
      _isLoading = false;
    });

    if (loginSuccess) {
      userController.resetLoginControllers(); // إعادة تعيين المتحكمات فقط عند نجاح عملية تسجيل الدخول
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Image(
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            image: AssetImage('assets/pic.jpg'),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'login'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 3,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomInputField(
                      controller: userController.loginPhoneNumberController,
                      labelText: 'phone'.tr,
                      hintText: 'phone'.tr,
                    ),
                    const SizedBox(height: 20),
                    CustomInputField(
                      controller: userController.loginPasswordController,
                      labelText: 'password'.tr,
                      hintText: 'password'.tr,
                      obscureText: true,
                      suffixIcon: true,
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: Row(
                        children: [
                          Obx(() => AnimatedSwitch(
                            value: userController.saveLoginInfo.value,
                            colorOff: const Color(0xffA09F99),
                            onChanged: (value) {
                              userController.saveLoginInfo.value = value;
                            },
                          )),
                          const SizedBox(width: 5),
                          Text(
                            'remember_me'.tr,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed('/forgot_password');
                            },
                            child: Text(
                              'forgot_password'.tr,
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 50,
                      width: 350,
                      decoration: const BoxDecoration(
                        color: Color(0xff0ACF83),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white) // مؤشر التحميل
                            : MaterialButton(
                                onPressed: _login,
                                child: Text(
                                  'login'.tr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 80.0, top: 30),
                      child: Row(
                        children: [
                          Text(
                            "don't_have_account".tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              Get.offAllNamed('/signup');
                            },
                            child: Text(
                              'signup'.tr,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.updateLocale(const Locale('en', 'US'));
                          },
                          child: const Text('English', style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            Get.updateLocale(const Locale('ar', 'SA'));
                          },
                          child: const Text('العربية', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
