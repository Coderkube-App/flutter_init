import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'hello_world': 'Hello World!!!',
          'no_internet_connection': 'No internet connection',
          'login': 'Login',
          'signup': 'Sign Up',
          'profile': 'Profile'
        }
      };
}
