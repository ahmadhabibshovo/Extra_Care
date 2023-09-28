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
    apiKey: 'AIzaSyA_a3jiFSUF-rWPXSB7zgfRan0u1teVRPs',
    appId: '1:85276858425:web:dd5b86b615003c412395e8',
    messagingSenderId: '85276858425',
    projectId: 'extracare-bafee',
    authDomain: 'extracare-bafee.firebaseapp.com',
    storageBucket: 'extracare-bafee.appspot.com',
    measurementId: 'G-2YNN5HF0BB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB0OGl8gsj8zqECk1juX7URR8vIG2MLzEA',
    appId: '1:85276858425:android:1054b28449c5b2242395e8',
    messagingSenderId: '85276858425',
    projectId: 'extracare-bafee',
    storageBucket: 'extracare-bafee.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA5uZkviJt-KDD0RFAI1XuR-kJdbWfsny0',
    appId: '1:85276858425:ios:d312c28c5268fce42395e8',
    messagingSenderId: '85276858425',
    projectId: 'extracare-bafee',
    storageBucket: 'extracare-bafee.appspot.com',
    iosBundleId: 'com.appfury.extracare.extraCare',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA5uZkviJt-KDD0RFAI1XuR-kJdbWfsny0',
    appId: '1:85276858425:ios:e9d3e9bac025f53d2395e8',
    messagingSenderId: '85276858425',
    projectId: 'extracare-bafee',
    storageBucket: 'extracare-bafee.appspot.com',
    iosBundleId: 'com.appfury.extracare.extraCare.RunnerTests',
  );
}
