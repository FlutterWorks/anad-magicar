import 'package:anad_magicar/Routes.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/repository/user/user_repo.dart';
import 'package:anad_magicar/service/locator.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/login/login_page.dart';
import 'package:anad_magicar/ui/screen/login/login_screen.dart';
import 'package:anad_magicar/utils/check_status_connection.dart';

import 'package:flutter/material.dart';
import 'package:anad_magicar/Routes.dart' as myApp;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
Future<void> main() async {

  setupLocator();
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null)
          debugPrint('notification payload: ' + payload);

        selectNotificationSubject.add(payload);
      });
  new Routes();
}//=> runApp(MyApp());


