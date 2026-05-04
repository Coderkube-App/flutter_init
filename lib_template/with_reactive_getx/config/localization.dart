import 'package:get/get.dart';


class Localization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': english,
  };
}


Map<String, String> english = {
  'hello_world': 'Hello World!!!',
  'no_internet_connection': 'No internet connection',
};