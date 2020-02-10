import 'package:anad_magicar/model/apis/api_service.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceTypeItem extends StatelessWidget {
  ApiService serviceItem;
  ServiceTypeItem({Key key,this.serviceItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.only(top: 5.0,left: 5.0,right: 5.0,bottom: 5.0),
      child: Card(
        elevation: 0.0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white30,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          new Padding(padding: EdgeInsets.only(right: 10.0),
          child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
               Text(serviceItem.Description),
              ],
            ),),
        new Padding(padding: EdgeInsets.only(right: 10.0),
          child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(Translations.current.serviceDate(),style: TextStyle(fontSize: 16.0),),
                Text(serviceItem.ServiceDate,style: TextStyle(fontSize: 16.0))
              ],
            ),),
        new Padding(padding: EdgeInsets.only(right: 10.0),
          child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(Translations.current.alarmDate(),style: TextStyle(fontSize: 16.0),),
                Text(serviceItem.AlarmDate,style: TextStyle(fontSize: 16.0)),
                Container(
                  width: 34.0,
                  height: 34.0,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child:  Image.asset('assets/images/scar2.png'),color: Colors.pinkAccent),
              ],
            ),),
        new Padding(padding: EdgeInsets.only(right: 10.0),
          child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(Translations.current.alarmCount(),style: TextStyle(fontSize: 16.0),),
                Text(serviceItem.AlarmCount.toString(),style: TextStyle(fontSize: 16.0))
              ],
            ),),
          ],
        ),
       ),
      ),
    );
  }
}
