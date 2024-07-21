import 'package:findatherapistapp/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findatherapistapp/app_settings/app_general_settings.dart';
import 'package:findatherapistapp/app_settings/auth_config.dart';

class AuthorizationProvider extends ChangeNotifier {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final FirebaseAuth? _firebaseAuth =
      AuthConfig.useFirebase ? FirebaseAuth.instance : null;
  final GoogleSignIn _googleSignIn =
      GoogleSignIn(scopes: AuthConfig.googleSignInScopes);
  String? _authToken;
  User? _user;
  bool _isLoading = true;
  bool _isUser = false;
  bool _isTherapist = false;

  AuthorizationProvider() {
    _initializeUser();
  }

  String? get authToken => _authToken;
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isUser => _isUser;
  bool get isTherapist => _isTherapist;

  Future<void> _initializeUser() async {
    if (AuthConfig.useFirebase) {
      _user = _firebaseAuth?.currentUser;
      if (_user != null) {
        _authToken = _user!.uid;
        await _checkUserRole(_user!.uid);
      }
    } else {
      _authToken = await storage.read(key: 'auth_token');
    }

    if (DebugConfig.debugMode || DebugConfig.forceDebugScreen) {
      if (_authToken == null && _user == null) {
        debugPrint('[User is not authenticated.]');
      } else {
        debugPrint('[User is authenticated.]');
      }
    }

    if ((DebugConfig.bypassLoginScreen || DebugConfig.forceDebugScreen) &&
        (_authToken == null && _user == null)) {
      debugPrint('Signing user automatically...');
      GoogleSignInAccount? currentUser = await _googleSignIn.signIn();
      if (currentUser != null) {
        _user = await _handleSignIn(currentUser);
        if (_user != null) {
          _authToken = _user?.uid;
          await setAuthToken(_authToken!);
          await _checkUserRole(_user!.uid);
        }
      }
    }

    _isLoading = false;
    notifyListeners();

    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      if (account != null) {
        _user = await _handleSignIn(account);
        if (_user != null) {
          _authToken = _user?.uid;
          await setAuthToken(_authToken!);
          await _checkUserRole(_user!.uid);
        }
      } else {
        _user = null;
        _authToken = null;
      }
      notifyListeners();
    });

    GoogleSignInAccount? currentUser = await _googleSignIn.signInSilently();
    if (currentUser != null) {
      _user = await _handleSignIn(currentUser);
      if (_user != null) {
        _authToken = _user?.uid;
        await setAuthToken(_authToken!);
        await _checkUserRole(_user!.uid);
        notifyListeners();
      }
    }
  }

  Future<User?> _handleSignIn(GoogleSignInAccount account) async {
    try {
      final GoogleSignInAuthentication googleAuth =
          await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      if (AuthConfig.useFirebase) {
        final UserCredential authResult =
            await _firebaseAuth!.signInWithCredential(credential);
        return authResult.user;
      }
      return null;
    } catch (e) {
      debugPrint('Error during Google sign-in: $e');
      return null;
    }
  }

  Future<void> setAuthToken(String token) async {
    try {
      await storage.write(key: 'auth_token', value: token);
      _authToken = token;
      notifyListeners();
    } catch (error) {
      debugPrint('Error during setting auth token: $error');
    }
    _authToken = token;
    notifyListeners();
  }

  Future<void> clearAuthToken() async {
    await storage.delete(key: 'auth_token');
    _authToken = null;
    _user = null;
    debugPrint('Auth token cleared. User will be logged out.');
    notifyListeners();
  }

  Future<void> signOut(BuildContext context) async {
    if (DebugConfig.bypassLoginScreen) {
      debugPrint(
          'Error: Bypass Login Screen is on. Disable it from AppGeneralSettings.bypassLoginScreen in order to proceed with sign out.');
      return;
    }
    await clearAuthToken();
    if (AuthConfig.useFirebase) {
      await _firebaseAuth?.signOut();
    }

    if (AuthConfig.allowGoogleSignIn) {
      await _googleSignIn.signOut();
    }
  }

  bool get isAuthenticated =>
      !isLoading &&
      (DebugConfig.bypassLoginScreen ||
          (_authToken != null && _authToken!.isNotEmpty));

  Future<bool> signInWithEmail(String email, String password) async {
    bool success = false;
    try {
      debugPrint('Signing in with email/password...');

      if (AuthConfig.useFirebase) {
        final UserCredential authResult = await _firebaseAuth!
            .signInWithEmailAndPassword(email: email, password: password);
        _authToken = authResult.user!.uid;
        _user = authResult.user;
        await setAuthToken(_authToken!);
        await _checkUserRole(_user!.uid);
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
            _user = authResult?.user;
            await setAuthToken(_authToken!);
            await _checkUserRole(_user!.uid);
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

  Future<void> _checkUserRole(String userId) async {
    _isUser = await checkIfUserExists(userId);
    _isTherapist = await checkIfTherapistExists(userId);

    debugPrint(
        'Current user is a registered User: $_isUser, Current user is a registered Therapist: $_isTherapist');

    notifyListeners();
  }

  Future<bool> checkIfUserExists(String userId) async {
    DocumentSnapshot userDoc =
        await FirestoreService.instance.collection('users').doc(userId).get();
    return userDoc.exists;
  }

  Future<bool> checkIfTherapistExists(String userId) async {
    DocumentSnapshot therapistDoc = await FirestoreService.instance
        .collection('therapists')
        .doc(userId)
        .get();
    return therapistDoc.exists;
  }
}
