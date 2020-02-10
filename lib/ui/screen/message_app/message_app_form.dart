import 'package:anad_magicar/components/no_data_widget.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_message.dart';
import 'package:anad_magicar/ui/screen/message_app/message_app_item.dart';
import 'package:flutter/material.dart';

class MessageAppForm extends StatefulWidget {
  MessageAppForm({Key key}) : super(key: key);

  @override
  _MessageAppFormState createState() {
    return _MessageAppFormState();
  }
}

class _MessageAppFormState extends State<MessageAppForm> {
  
  Future<List<ApiMessage>> fMessages;
  List<ApiMessage> messages=new List();

  Future<List<ApiMessage>> getMessages() {
    var result=restDatasource.getUserMessage();
    if(result!=null )
      return result;
    return null;
  }
  @override
  void initState() {
    super.initState();
    fMessages=getMessages();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<List<ApiMessage>>(
      future: fMessages,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null) {
          messages = snapshot.data;
          return Material(
            color: Color(0xfffefefe),
            child: new Card(
              margin: new EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 78.0, bottom: 5.0),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black54,width: 0.5),
                  borderRadius: BorderRadius.circular(8.0)),
              elevation: 0.0,
              child:
              new Container(
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  color: Color(0xfffefefe),
                  borderRadius: new BorderRadius.all(
                      new Radius.circular(5.0)),
                ),
                child:
                ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return
                        MessageAppItem(message : messages[index]);
                    }
                ),
              ),
            ),
          );
        } else {
          return NoDataWidget(noCarCount: false,);
        }
      },
    );
  }
}
