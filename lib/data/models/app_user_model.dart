import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:supermarket/domain/entities/app_user_entity.dart';

class AppUserModel extends AppUser {
  AppUserModel(super.id, super.email, super.name);

  factory AppUserModel.fromFirebaseUser(firebase.User firebaseUser) {
    return AppUserModel(
      firebaseUser.uid,
      firebaseUser.email,
      firebaseUser.displayName,
    );
  }
}
