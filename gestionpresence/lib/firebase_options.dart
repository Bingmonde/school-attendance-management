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
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyAJyyojmD-3vSgZrLRvO9kKB8igiarraWM',
    appId: '1:952290383027:web:6ec5f6a25b245cc0144cc6',
    messagingSenderId: '952290383027',
    projectId: 'gestion456bing',
    authDomain: 'gestion456bing.firebaseapp.com',
    storageBucket: 'gestion456bing.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDnMKsUxtfQaMu4uW_G56T4vCNaKeKrpT4',
    appId: '1:952290383027:android:781deab205933921144cc6',
    messagingSenderId: '952290383027',
    projectId: 'gestion456bing',
    storageBucket: 'gestion456bing.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCb0KXHPZwQRchfQRoI_Mbgc-2mDM97QEU',
    appId: '1:952290383027:ios:f23cf88ae2c9af20144cc6',
    messagingSenderId: '952290383027',
    projectId: 'gestion456bing',
    storageBucket: 'gestion456bing.appspot.com',
    iosBundleId: 'ca.alaurent.bingqing.gestionpresence',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCb0KXHPZwQRchfQRoI_Mbgc-2mDM97QEU',
    appId: '1:952290383027:ios:f23cf88ae2c9af20144cc6',
    messagingSenderId: '952290383027',
    projectId: 'gestion456bing',
    storageBucket: 'gestion456bing.appspot.com',
    iosBundleId: 'ca.alaurent.bingqing.gestionpresence',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAJyyojmD-3vSgZrLRvO9kKB8igiarraWM',
    appId: '1:952290383027:web:e024b086c30b0636144cc6',
    messagingSenderId: '952290383027',
    projectId: 'gestion456bing',
    authDomain: 'gestion456bing.firebaseapp.com',
    storageBucket: 'gestion456bing.appspot.com',
  );
}
