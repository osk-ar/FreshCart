import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supermarket/core/utils/extensions.dart';

class AuthFirebaseDatasource {
  AuthFirebaseDatasource(this._googleSignIn);

  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      throw (e as Exception).mapExceptionToFailure(StackTrace.current);
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the Google authentication flow.
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If the user cancelled the process, return null.
      if (googleUser == null) {
        return null;
      }

      // Obtain the auth details from the request.
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential for Firebase.
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential.
      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      // Handle other potential errors.
      rethrow;
    }
  }

  /// Signs in the user anonymously as a guest.
  ///
  /// This creates a temporary user account.
  /// Returns the [UserCredential] for the anonymous user.
  /// Throws a [FirebaseAuthException] if the sign-in fails.
  Future<UserCredential> signInAnonymously() async {
    try {
      final userCredential = await _firebaseAuth.signInAnonymously();
      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    }
  }
}
