import 'package:flutter_with_reactive_getx/core/storage/app_storage.dart';

class StorageService {
  String? readString(String key) => AppStorage.box.read<String>(key);

  Future<void> writeString(String key, String value) async {
    await AppStorage.box.write(key, value);
  }
}
