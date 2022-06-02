import 'package:online_yoklama/core/extension/init/models/user_model.dart';

abstract class AdminHomeBase {
  Future<UserModel> getAdminInformation({required String userID});
}
