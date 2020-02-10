import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_service.dart';
import 'package:anad_magicar/model/viewmodel/service_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/service/register_service_page.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:anad_magicar/widgets/flash_bar/flash_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceItem extends StatelessWidget {
  ApiService serviceItem;
  ServiceItem({Key key,this.serviceItem}) : super(key: key);


  deleteService(ApiService sItem,BuildContext context,bool mode) async{
    sItem.RowStateType=mode ? Constants.ROWSTATE_TYPE_UPDATE :
     Constants.ROWSTATE_TYPE_DELETE;
    if(!mode) {
      var result = await restDatasource.saveCarService(sItem);
      if (result != null) {
        if (result.IsSuccessful) {
          // FlashHelper.successBar(context, message: result.Message);
          centerRepository.showFancyToast(result.Message);
        }
        else {
          //FlashHelper.errorBar(context, message: result.Message);
          centerRepository.showFancyToast(result.Message);
        }
      }
    }
    else{
      Navigator.pushNamed(context, RegisterServicePageState.route,arguments: new ServiceVM(carId: serviceItem.CarId,
          editMode: true, service: serviceItem));
    }
  }

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
               Text(DartHelper.isNullOrEmptyString( serviceItem.Description)),
              ],
            ),),
        new Padding(padding: EdgeInsets.only(right: 10.0),
          child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(Translations.current.serviceDate(),style: TextStyle(fontSize: 16.0),),
                Text(DartHelper.isNullOrEmptyString(serviceItem.ServiceDate),style: TextStyle(fontSize: 16.0))
              ],
            ),),
        new Padding(padding: EdgeInsets.only(right: 10.0),
          child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(Translations.current.alarmDate(),style: TextStyle(fontSize: 16.0),),
                Text(DartHelper.isNullOrEmptyString(serviceItem.AlarmDate),style: TextStyle(fontSize: 16.0)),
                Container(
                  width: 34.0,
                  height: 34.0,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child:  Image.asset('assets/images/scar2.png',color: Colors.pinkAccent),)
              ],
            ),),
        new Padding(padding: EdgeInsets.only(right: 10.0),
          child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(Translations.current.alarmCount(),style: TextStyle(fontSize: 16.0),),
                Text(serviceItem.AlarmCount!=null ? DartHelper.isNullOrEmptyString(serviceItem.AlarmCount.toString()) : '',style: TextStyle(fontSize: 16.0))
              ],
            ),),
            new Padding(padding: EdgeInsets.only(right: 10.0),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child:
                    Button(title: Translations.current.edit(),color: Colors.pinkAccent.value,wid: 100.0,),
                    onPressed: (){ deleteService(serviceItem,context,true); },
                  ),
                  FlatButton(
                    child:
                  Button(title: Translations.current.delete(),color: Colors.pinkAccent.value,wid: 100.0,),
                    onPressed: (){ deleteService(serviceItem,context,false); },
                  ),
                ],
              ),),
          ],
        ),
       ),
      ),
    );
  }
}
