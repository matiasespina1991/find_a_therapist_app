// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDveJYPGHPx9V8qq1Ax3Vg2MfocCJkVAhA',
    appId: '1:884785471762:android:d6c4cf1dc8bcec35abd3cb',
    messagingSenderId: '884785471762',
    projectId: 'find-a-therapist-app',
    storageBucket: 'find-a-therapist-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDeEn5w_S__vLaUUVodC6-rfphRQgRifYk',
    appId: '1:884785471762:ios:163a442aa1f0254cabd3cb',
    messagingSenderId: '884785471762',
    projectId: 'find-a-therapist-app',
    storageBucket: 'find-a-therapist-app.appspot.com',
    androidClientId: '884785471762-nbdugrtnpb1v62fil4jqklovkjv0g7rq.apps.googleusercontent.com',
    iosClientId: '884785471762-3dgjeptfoefi4bj7p8likjcadb6oaet1.apps.googleusercontent.com',
    iosBundleId: 'com.matiasespina1991.template',
  );
}
