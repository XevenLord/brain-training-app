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
    apiKey: 'AIzaSyBNdGzgMgPNnoJs-odXdlMgDzhUPgIHWsM',
    appId: '1:691537332877:web:f0baf858a025d9e70b30c4',
    messagingSenderId: '691537332877',
    projectId: 'neurofit-brain-training-app',
    authDomain: 'neurofit-brain-training-app.firebaseapp.com',
    storageBucket: 'neurofit-brain-training-app.appspot.com',
    measurementId: 'G-2P1YF5TN19',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBM_UnVXOa3tgRbGHb6a5KF_aYK_ucqqc8',
    appId: '1:691537332877:android:632064f0fd2222fe0b30c4',
    messagingSenderId: '691537332877',
    projectId: 'neurofit-brain-training-app',
    storageBucket: 'neurofit-brain-training-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBpp1hHgz6YjI_wGYkMqeId2MYs8f_--r0',
    appId: '1:691537332877:ios:e6b11e397ea1e54b0b30c4',
    messagingSenderId: '691537332877',
    projectId: 'neurofit-brain-training-app',
    storageBucket: 'neurofit-brain-training-app.appspot.com',
    iosClientId: '691537332877-ftm7qgd2abtp33du7hh12gqd19odn654.apps.googleusercontent.com',
    iosBundleId: 'com.example.brainTrainingApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBpp1hHgz6YjI_wGYkMqeId2MYs8f_--r0',
    appId: '1:691537332877:ios:e6b11e397ea1e54b0b30c4',
    messagingSenderId: '691537332877',
    projectId: 'neurofit-brain-training-app',
    storageBucket: 'neurofit-brain-training-app.appspot.com',
    iosClientId: '691537332877-ftm7qgd2abtp33du7hh12gqd19odn654.apps.googleusercontent.com',
    iosBundleId: 'com.example.brainTrainingApp',
  );
}
