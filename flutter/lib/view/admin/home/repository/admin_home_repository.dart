import 'package:online_yoklama/core/base/admin_home_base.dart';
import 'package:online_yoklama/core/constants/app_mode.dart';
import 'package:online_yoklama/core/extension/init/models/user_model.dart';
import 'package:online_yoklama/locator.dart';
import 'package:online_yoklama/view/admin/home/services/firestore_adminhome_service.dart';

class AdminHomeRepository extends AdminHomeBase {
  final FirestoreAdminHomeService _firestoreAdminHomeService =
      locator<FirestoreAdminHomeService>();
  @override
  Future<UserModel> getAdminInformation({required String? userID}) async {
    if (AppMode.appMode == AppStatus.DEBUG) {
      return await _firestoreAdminHomeService.getAdminInformation(
          userID: userID);
    } else {
      return await _firestoreAdminHomeService.getAdminInformation(
          userID: userID);
    }
  }
}
