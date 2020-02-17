import 'dart:collection';

import 'package:anad_magicar/components/no_data_widget.dart';
import 'package:anad_magicar/components/pull_refresh/pull_to_refresh.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_message.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/message_app/message_app_item.dart';
import 'package:flutter/material.dart';
import "package:collection/collection.dart";
class MessageAppForm extends StatefulWidget {
  int carId;
  MessageAppForm({Key key,this.carId}) : super(key: key);

  @override
  _MessageAppFormState createState() {
    return _MessageAppFormState();
  }
}

class _MessageAppFormState extends State<MessageAppForm> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  Future<List<ApiMessage>> fMessages;
  List<ApiMessage> messages=new List();
  List<Map<String,dynamic>> mapList=new List();

  HashMap<int,List<ApiMessage>> recMessages=new HashMap();

  Future<List<ApiMessage>> getMessages() {
    var result=restDatasource.getUserMessage();
    if(result!=null ) {
      return result;
    }
    return null;
  }


  Future<List<ApiMessage>> refreshMessageApp() async
  {
   getMessages();
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
    return
      SmartRefresher(

          controller: _refreshController,
          enablePullUp: true,
          enablePullDown: true,
          physics: BouncingScrollPhysics(),
          footer: MaterialClassicHeader(
            color: Theme.of(context).indicatorColor,
            height: 10.0,
            backgroundColor: Theme.of(context).backgroundColor,
            //loadStyle: LoadStyle.ShowWhenLoading,
            //completeDuration: Duration(milliseconds: 500),
          ),
          header: WaterDropMaterialHeader(),
          onRefresh: () async {
            //monitor fetch data from network
            await Future.delayed(Duration(milliseconds: 1000));

            var result=   await refreshMessageApp();
            if (mounted) setState(() {});
            if(result==null)
              _refreshController.refreshFailed();
            else
              _refreshController.refreshCompleted();

          },
          onLoading:() async {
            //monitor fetch data from network
            await Future.delayed(Duration(milliseconds: 1000));
            var result= await refreshMessageApp();
            if (mounted) setState(() {});
            if(result==null)
              _refreshController.loadFailed();
            else
              _refreshController.loadComplete();
          },
          child:

          ListView.builder(
          padding: EdgeInsets.only(top:1.0), //kMaterialListPadding,
    itemCount: 1,
    itemBuilder: (BuildContext context, int index)
    {

    return
      FutureBuilder<List<ApiMessage>>(
      future: fMessages,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null) {
          messages = snapshot.data;
          mapList=messages.map((m)=>m.toMap()).toList();
         Map<int,List<Map<String,dynamic>>> recIds=groupBy(mapList,(o)=>o['SenderUserId']);

          return new Container(
            height: 450.0,
            child:
            new Card(
              margin: new EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 78.0, bottom: 5.0),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white,width: 0.5),
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
                        MessageAppItem(messages : recIds,carId: widget.carId,),
              ),
            ),
          );
        } else {
          return NoDataWidget(noCarCount: false,);
        }
      },
    );
    },
          ),
      );
  }
}
