import 'dart:async';

import 'package:anad_magicar/components/flushbar/flushbar.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/firebase/message/firebase_message_handler.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/widgets/dialog/android_alert_dialog.dart';
import 'package:anad_magicar/widgets/dialog/base_dialog.dart';
import 'package:anad_magicar/widgets/dialog/ios_alert_dialog.dart';
import 'package:anad_magicar/widgets/flushbar.dart';
import 'package:flutter/material.dart';


class MessageHandler extends FireBaseMessageHandler {

  BuildContext context;
  Function sendMessage;

  MessageHandler({
    @required this.context,
    @required this.sendMessage
  });

  final List<CustomDialog> customDialogList = [
    AndroidAlertDialog(),
    IosAlertDialog(),
  ];

  CustomDialog customDialog;
  int _selectedDialogIndex = 0;

  Future _showCustomDialog(BuildContext context) async {
    var selectedDialog = customDialogList[_selectedDialogIndex];

    await selectedDialog.show(context);
  }


  @override
  hasToken(bool hasToken, String token) {
    if(hasToken) {
      prefRepository.setFCMToken(token,);
    }
    return hasToken;
  }

  @override
  onLaunch(Map<String, dynamic> message) {
    // TODO: implement onLaunch
    return null;
  }

  @override
  onResume(Map<String, dynamic> message) {
    // TODO: implement onResume
    return null;
  }

  @override
  showMessage(Map<String, dynamic> message) {
    // TODO: implement showMessage
    String title=message['notification']['title'];
    String messageBody=message['notification']['body'];
    /*if(Platform.isIOS)
      {
       customDialog= IosAlertDialog(title: title,
       message: messageBody);
      }
    else if(Platform.isAndroid)
      {
        customDialog= AndroidAlertDialog(title: title,
            message: messageBody);
      }
    customDialog.show(context);*/

    sendMessage(message);

    return null;
  }



}
