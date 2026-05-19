import 'package:dating_user/core/constant/storage_keys.dart';
import 'package:get_storage/get_storage.dart';

class StorageHelper {
  var storage = GetStorage();

  Map<String, dynamic> getHeaderWithToken() {
    return {"UserToken": storage.read<String>(StorageKeys.token) ?? ""};
  }


}
