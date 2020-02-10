
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

abstract class FireBaseMessageHandler<T> {

  showMessage(Map<String, dynamic> message);
  onLaunch(Map<String, dynamic> message);
  onResume (Map<String, dynamic> message);
  hasToken(bool hasToken, String token);

  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;



  Future<T> myBackgroundMessageHandler(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      final dynamic notification = message['notification'];
    }

  }

  Future<String> getClientToken() async {
    String fcmToken = await _fcm.getToken();
    hasToken((fcmToken!=null && fcmToken.isNotEmpty), fcmToken);
    return fcmToken;
  }

  void initMessageHandler() {
    getClientToken();
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }


    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        showMessage(message);
      },

      //onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
       onLaunch(message);
      },
      onResume: (Map<String, dynamic> message) async {
        onResume(message);
      },
    );
  }
}
