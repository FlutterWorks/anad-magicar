import 'package:anad_magicar/model/apis/api_message.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:flutter/material.dart';

class MessageAppItem extends StatefulWidget {

  ApiMessage message;
  MessageAppItem({Key key,this.message}) : super(key: key);

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
    return new Card(
      margin: new EdgeInsets.only(
          left: 5.0, right: 5.0, top: 8.0, bottom: 5.0),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black54,width: 0.0),
          borderRadius: BorderRadius.circular(8.0)),
      elevation: 0.0,
      child:
      new Container(
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          color: Color(0xffe0e0e0),
          borderRadius: new BorderRadius.all(
              new Radius.circular(5.0)),
        ),
        child:
        new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Padding(padding: EdgeInsets.only(right: 10.0),
              child:
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(Translations.current.messageDate(),style: TextStyle(fontSize: 16.0),),
                  new Padding(padding: EdgeInsets.only(right: 10.0,left: 5.0),
                    child: Text( widget.message.MessageDate.toString(),style: TextStyle(fontSize: 16.0),
                      overflow: TextOverflow.fade,softWrap: true,),),

               new Padding(padding: EdgeInsets.only(right: 10.0,left: 20.0),
                    child: Container(
                      width: 34.0,
                      height: 34.0,
                      child:
                      widget.message.MessageStatusConstId!=ApiMessage.MESSAGE_STATUS_AS_READ_TAG ?
                      Image.asset('assets/images/unread.png',color: Colors.pinkAccent,) :
                      Image.asset('assets/images/read.png',color: Colors.pinkAccent,) ,),),

                ],
              ),
            ),
            new Padding(padding: EdgeInsets.only(right: 10.0),
              child:
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(DartHelper.isNullOrEmptyString( widget.message.MessageSubject),style: TextStyle(fontSize: 16.0),)
                ],
              ),),

            new Padding(padding: EdgeInsets.only(right: 10.0),
              child:
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Padding(padding: EdgeInsets.only(right: 10.0,left: 20.0),
                    child:
                    Text(widget.message.MessageBody,style: TextStyle(fontSize: 16.0),overflow: TextOverflow.ellipsis,softWrap: true,),),
                ],
              ),),
            new Padding(padding: EdgeInsets.only(right: 10.0),
              child:
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              Text(DartHelper.isNullOrEmptyString( widget.message.Description) ,style: TextStyle(fontSize: 16.0),),
          ],
              ),),
          ],
        ),
      ),
    );
  }
}
