// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyExampleKey1234567890',
    appId: '1:123456789012:android:abcdef123456',
    messagingSenderId: '123456789012',
    projectId: 'observador-123',
    storageBucket: 'observador-123.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyExampleKey1234567890',
    appId: '1:123456789012:ios:abcdef123456',
    messagingSenderId: '123456789012',
    projectId: 'observador-123',
    storageBucket: 'observador-123.appspot.com',
    iosBundleId: 'com.thyrrel.observador',
    iosClientId: '123456789012-abcdefg.apps.googleusercontent.com',
    androidClientId: '1:123456789012:android:abcdef123456',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyExampleKey1234567890',
    appId: '1:123456789012:web:abcdef123456',
    messagingSenderId: '123456789012',
    projectId: 'observador-123',
    storageBucket: 'observador-123.appspot.com',
  );
}
