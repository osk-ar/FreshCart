import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supermarket/core/utils/extensions.dart';
import 'package:supermarket/data/models/app_user_model.dart';

class AuthRemoteDatasource {
  AuthRemoteDatasource(this._googleSignIn);

  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<AppUserModel?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      await user?.updateDisplayName(name);
      return AppUserModel.fromFirebaseUser(user!);
    } catch (e) {
      throw e.mapExceptionToFailure(StackTrace.current);
    }
  }

  Future<AppUserModel?> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AppUserModel.fromFirebaseUser(userCredential.user!);
    } catch (e) {
      throw e.mapExceptionToFailure(StackTrace.current);
    }
  }

  Future<AppUserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential.
      final user = await _firebaseAuth.signInWithCredential(credential);
      return AppUserModel.fromFirebaseUser(user.user!);
    } catch (e) {
      throw e.mapExceptionToFailure(StackTrace.current);
    }
  }

  //todo look at guest sign in
  Future<UserCredential> signInAnonymously() async {
    try {
      final userCredential = await _firebaseAuth.signInAnonymously();
      return userCredential;
    } catch (e) {
      throw e.mapExceptionToFailure(StackTrace.current);
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      throw e.mapExceptionToFailure(StackTrace.current);
    }
  }
}
