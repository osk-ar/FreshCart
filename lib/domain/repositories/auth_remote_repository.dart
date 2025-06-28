import 'package:supermarket/domain/entities/app_user_entity.dart';

abstract class AuthRemoteRepository {
  Future<AppUser?> signInWithGoogle();
  Future<AppUser?> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  );
  Future<AppUser?> loginWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}
