import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_yoklama/core/base/admin_home_base.dart';
import 'package:online_yoklama/core/constants/paths.dart';
import 'package:online_yoklama/core/extension/init/models/user_model.dart';
import 'package:online_yoklama/locator.dart';

class FirestoreAdminHomeService extends AdminHomeBase {
  final FirebaseFirestore _firebaseFirestore = locator<FirebaseFirestore>();
  @override
  Future<UserModel> getAdminInformation({required String? userID}) async {
    var response =
        await _firebaseFirestore.collection(Paths.users).doc(userID).get();
    return UserModel.fromMap(response.data()!);
  }
}
