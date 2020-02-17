import 'package:anad_magicar/model/apis/api_message.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/message_app/message_expandable_panel.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:flutter/material.dart';

class MessageAppItem extends StatefulWidget {

  ApiMessage message;
  int carId;
  Map<int,List<Map<String,dynamic>>> messages;
  MessageAppItem({Key key,this.message,this.messages,this.carId}) : super(key: key);

  @override
  _MessageAppItemState createState() {
    return _MessageAppItemState();
  }
}

class _MessageAppItemState extends State<MessageAppItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MessageExpandPanel(messages: widget.messages,carId: widget.carId,);
  }
}
