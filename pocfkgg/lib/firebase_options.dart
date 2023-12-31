// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCuHdA6JKmlqQzqNgMVsn-qXcvECkNAGU0',
    appId: '1:294240328671:web:d6e0581a72f4f2f765c26a',
    messagingSenderId: '294240328671',
    projectId: 'proof-of-concept-fkgg',
    authDomain: 'proof-of-concept-fkgg.firebaseapp.com',
    storageBucket: 'proof-of-concept-fkgg.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDbALJO_HO3yHREri2w7Wku0cS0ZKud4Bc',
    appId: '1:294240328671:android:843db95921ebd6f465c26a',
    messagingSenderId: '294240328671',
    projectId: 'proof-of-concept-fkgg',
    storageBucket: 'proof-of-concept-fkgg.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDiw0OemhEtTKPbwLaqN_MZ_VWW9QjMl84',
    appId: '1:294240328671:ios:aa43a0d8638a08fa65c26a',
    messagingSenderId: '294240328671',
    projectId: 'proof-of-concept-fkgg',
    storageBucket: 'proof-of-concept-fkgg.appspot.com',
    iosBundleId: 'com.example.pocfkgg',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDiw0OemhEtTKPbwLaqN_MZ_VWW9QjMl84',
    appId: '1:294240328671:ios:b61f6c3a4246fb0265c26a',
    messagingSenderId: '294240328671',
    projectId: 'proof-of-concept-fkgg',
    storageBucket: 'proof-of-concept-fkgg.appspot.com',
    iosBundleId: 'com.example.pocfkgg.RunnerTests',
  );
}
