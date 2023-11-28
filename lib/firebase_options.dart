// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// 
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
    apiKey: 'AIzaSyC5xwh86rhBLrmu0mk-dv6Qql1_C9YoyF4',
    appId: '1:947453899984:web:35b72b913c811faaf99ad5',
    messagingSenderId: '947453899984',
    projectId: 'chat-live-c1715',
    authDomain: 'chat-live-c1715.firebaseapp.com',
    storageBucket: 'chat-live-c1715.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCFMr4Y5Yal2PMwRf8bufBMWe_CUfpN23k',
    appId: '1:947453899984:android:0b095f8697163bbff99ad5',
    messagingSenderId: '947453899984',
    projectId: 'chat-live-c1715',
    storageBucket: 'chat-live-c1715.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDqq29PMk7ULGKHKO33PlAa36UHuASG_Z4',
    appId: '1:947453899984:ios:41243dba28112f9af99ad5',
    messagingSenderId: '947453899984',
    projectId: 'chat-live-c1715',
    storageBucket: 'chat-live-c1715.appspot.com',
    iosBundleId: 'com.example.langoApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDqq29PMk7ULGKHKO33PlAa36UHuASG_Z4',
    appId: '1:947453899984:ios:55a56c7968cff908f99ad5',
    messagingSenderId: '947453899984',
    projectId: 'chat-live-c1715',
    storageBucket: 'chat-live-c1715.appspot.com',
    iosBundleId: 'com.example.langoApp.RunnerTests',
);
}