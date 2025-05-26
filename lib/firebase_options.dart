// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // Konfigurasi Firebase Web
      return const FirebaseOptions(
        apiKey: 'API_KEY_WEB',
        authDomain: 'PROJECT_ID.firebaseapp.com',
        projectId: 'PROJECT_ID',
        storageBucket: 'PROJECT_ID.appspot.com',
        messagingSenderId: 'SENDER_ID',
        appId: 'APP_ID',
        measurementId: 'MEASUREMENT_ID',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: 'API_KEY_ANDROID',
          appId: 'APP_ID_ANDROID',
          messagingSenderId: 'SENDER_ID_ANDROID',
          projectId: 'PROJECT_ID',
          storageBucket: 'PROJECT_ID.appspot.com',
        );
      case TargetPlatform.iOS:
        return const FirebaseOptions(
          apiKey: 'API_KEY_IOS',
          appId: 'APP_ID_IOS',
          messagingSenderId: 'SENDER_ID_IOS',
          projectId: 'PROJECT_ID',
          storageBucket: 'PROJECT_ID.appspot.com',
          iosBundleId: 'BUNDLE_ID_IOS',
          iosClientId: 'CLIENT_ID_IOS',
        );
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }
}
