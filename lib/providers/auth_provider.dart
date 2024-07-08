import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:template_app/app_settings/app_general_settings.dart';
import 'package:template_app/app_settings/auth_config.dart';

class AuthorizationProvider extends ChangeNotifier {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final FirebaseAuth? _firebaseAuth =
      AuthConfig.useFirebase ? FirebaseAuth.instance : null;

  final GoogleSignIn _googleSignIn =
      GoogleSignIn(scopes: AuthConfig.googleSignInScopes);
  String? _authToken;

  AuthorizationProvider() {
    _loadAuthToken();
  }

  String? get authToken => _authToken;

  Future<void> _loadAuthToken() async {
    _authToken = await storage.read(key: 'auth_token');
    notifyListeners();
  }

  Future<void> setAuthToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
    _authToken = token;
    notifyListeners();
  }

  Future<void> clearAuthToken() async {
    await storage.delete(key: 'auth_token');
    _authToken = null;
    debugPrint('Auth token cleared. User will be logged out.');
    notifyListeners();
  }

  Future<void> signOut(BuildContext context) async {
    if (DebugConfig.debugMode) {
      debugPrint(
          'Error: Debug mode is on. Disable it from AppGeneralSettings.debugMode in order to proceed with sign out.');
      return;
    }
    await clearAuthToken();
    if (AuthConfig.useFirebase) {
      await _firebaseAuth?.signOut();
    }
  }

  bool get isAuthenticated =>
      DebugConfig.debugMode || (_authToken != null && _authToken!.isNotEmpty);

  Future<bool> signInWithEmail(String email, String password) async {
    bool success = false;
    try {
      debugPrint('Signing in with email/password...');

      if (AuthConfig.useFirebase) {
        final UserCredential authResult = await _firebaseAuth!
            .signInWithEmailAndPassword(email: email, password: password);
        _authToken = authResult.user!.uid;
        await setAuthToken(_authToken!);
      } else {
        _authToken = email;
        await setAuthToken(_authToken!);
      }

      notifyListeners();
      success = true;
      debugPrint('User logged in successfully.✅');
      return success;
    } catch (error) {
      debugPrint('Error during email/password Sign In: ${error.toString()}');
      success = false;
      return success;
    }
  }

  Future<bool> signInWithGoogle() async {
    bool success = false;
    if (AuthConfig.allowGoogleSignIn) {
      try {
        debugPrint('Signing in with Google...');

        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser != null) {
          debugPrint('Google Sign In successful.');
          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          if (AuthConfig.useFirebase) {
            final UserCredential? authResult =
                await _firebaseAuth?.signInWithCredential(credential);
            _authToken = authResult?.user!.uid;
            await setAuthToken(_authToken!);
          } else {
            _authToken = googleAuth.accessToken;
            await setAuthToken(_authToken!);
          }

          notifyListeners();
          success = true;
          debugPrint('User logged in successfully.');
          return success;
        }
      } catch (error) {
        debugPrint(
            'Error trying to signing in user using Google: ${error.toString()}');
        success = false;
        return success;
      }
    }
    return success;
  }
}
