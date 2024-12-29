import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'hello': 'Hello',
      'signup': 'Sign Up',
      'login': 'Login',
      'phone': 'Phone Number',
      'password': 'Password',
      'location': 'Your Location',
      'already_have_account': 'Already have an account?',
      'remember_me': 'Remember me',
      "don't_have_account": "Don't have an account?",
      'first_name': 'First Name',
      'last_name': 'Last Name',
      'forgot_password': 'Forgot Password', 
    },
    'ar_SA': {
      'hello': 'مرحبا',
      'signup': 'إنشاء حساب',
      'login': 'تسجيل الدخول',
      'phone': 'رقم الهاتف',
      'password': 'كلمة المرور',
      'location': 'موقعك',
      'already_have_account': 'هل لديك حساب بالفعل؟',
      'remember_me': 'تذكرني',
      "don't_have_account": "ليس لديك حساب؟",
      'first_name': 'الاسم الأول',
      'last_name': 'الاسم الأخير',
      'forgot_password': 'نسيت كلمة المرور', 
    }
  };
}
