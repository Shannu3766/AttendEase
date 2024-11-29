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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDLdMpE2USUjPY4VP3yCkq4_B-5DamdSyc',
    appId: '1:36391741820:web:1a908b9910a52a28aadcf9',
    messagingSenderId: '36391741820',
    projectId: 'attendease-54526',
    authDomain: 'attendease-54526.firebaseapp.com',
    storageBucket: 'attendease-54526.firebasestorage.app',
    measurementId: 'G-R7NJRJGQSS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCQCKIZwU8j6vRhQ7Nce4fWqH9-hODw1Lw',
    appId: '1:36391741820:android:d09b42597902a973aadcf9',
    messagingSenderId: '36391741820',
    projectId: 'attendease-54526',
    storageBucket: 'attendease-54526.firebasestorage.app',
  );

}