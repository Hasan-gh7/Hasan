import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro/controller/usercontroller.dart';
import 'package:pro/widgets/pick_image_widget.dart';
import 'package:pro/widgets/textfield.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final UserController userController = Get.put(UserController());
  bool _isLoading = false; // متغير لتتبع حالة التحميل

  void _signup() async {
    setState(() {
      _isLoading = true;
    });
    await userController.signup(context);
    setState(() {
      _isLoading = false;
    });
    // إعادة تعيين المتحكمات بعد إتمام عملية التسجيل بنجاح
    userController.resetSignupControllers();
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
            image: AssetImage('assets/pic2.jpg'),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.15),
                  Colors.black.withOpacity(0.5),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 1),
                  Text(
                    'signup'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const PickImageWidget(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CustomInputField(
                      labelText: 'first_name'.tr,
                      hintText: 'first_name'.tr,
                      controller: userController.firstNameController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2),
                    child: CustomInputField(
                      labelText: 'last_name'.tr,
                      hintText: 'last_name'.tr,
                      controller: userController.lastNameController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2),
                    child: CustomInputField(
                      labelText: 'phone'.tr,
                      hintText: 'phone'.tr,
                      controller: userController.signupPhoneNumberController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2),
                    child: CustomInputField(
                      labelText: 'password'.tr,
                      hintText: 'password'.tr,
                      obscureText: true,
                      suffixIcon: true,
                      controller: userController.signupPasswordController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomInputField(
                            labelText: 'location'.tr,
                            hintText: 'location'.tr,
                            controller: userController.locationController,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.location_on, color: Colors.white),
                          onPressed: () async {
                            await userController.getLocation();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _signup,
                    child: Container(
                      height: 50,
                      width: 350,
                      decoration: const BoxDecoration(color: Color(0xff0ACF83)),
                      child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white) // مؤشر التحميل
                            : Text(
                                'signup'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 100.0, top: 15),
                    child: Row(
                      children: [
                        Text(
                          'already_have_account'.tr,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Get.offAllNamed('login');
                          },
                          child: Text(
                            'login'.tr,
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
                        child: const Text('English'),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {
                          Get.updateLocale(const Locale('ar', 'SA'));
                        },
                        child: const Text('العربية'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
