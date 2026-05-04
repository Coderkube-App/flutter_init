import 'package:flutter_with_reactive_getx/core/network/api_client.dart';
import 'package:flutter_with_reactive_getx/data/providers/auth_provider.dart';
import 'package:flutter_with_reactive_getx/data/repositories/auth_repository_impl.dart';
import 'package:flutter_with_reactive_getx/modules/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => AuthProvider(Get.find<ApiClient>()));
    Get.lazyPut(() => AuthRepositoryImpl(Get.find<AuthProvider>()));
    Get.lazyPut(() => AuthViewModel(Get.find<AuthRepositoryImpl>()));
  }
}
