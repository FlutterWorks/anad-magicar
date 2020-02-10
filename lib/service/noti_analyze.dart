
import 'dart:collection';

import 'package:anad_magicar/common/actions_constants.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart' as carEnum;
import 'package:anad_magicar/model/viewmodel/status_noti_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:flutter/material.dart';

class NotiAnalyze {

 String noti;
 int carId;

 static HashMap<int,CarStateVM> actionCommandsNotiMap=new HashMap();
 static HashMap<carEnum.CarStatus,int> carNotiMap=new HashMap();
 static HashMap<carEnum.CarStatus,bool> carNotiMap2=new HashMap();
 static StatusNotiVM statusNotiVM;

 NotiAnalyze({
   @required this.noti,
   @required this.carId,
 });

 static int getCarIdFromNoty(String noti) {
   var notiItem=noti.split(',');
   if(notiItem!=null && notiItem.length>0) {
     List<String> carIds=notiItem.where((c)=>c==ActionsCommand.CAR_ID_TAG).toList();
     if(carIds!=null && carIds.length>0)
       {
         return int.tryParse( carIds.first);
       }
   }
 }

  StatusNotiVM decodeStatus(String statusBits, int index) {
   statusNotiVM=new StatusNotiVM();
   if(index==1)
     {
       decodeStatus1(statusBits);

     }
   if(index==2)
   {
     decodeStatus2(statusBits);

   }
   if(index==3)
   {
     decodeStatus3(statusBits);

   }

   if(index==4)
   {
     decodeFeature1(statusBits);

   }
   if(index==5)
   {
     decodeFeature2(statusBits);

   }
   if(index==6)
   {
     decodeFeature3(statusBits);
   }
   if(index==7)
   {
     decodeData6(statusBits);

   }
   if(index==8)
   {
     decodeData7(statusBits);
   }
  return statusNotiVM;
 }


 static decodeStatus1(String statusBits) {
   String statusNoti='';

     for(var i=0;i<statusBits.length;i++) {
       String bitItem = statusBits.substring(i,i);
       if(i==0) statusNotiVM.arm=bitItem=='1' ? true : false  ;
       if(i==1) statusNotiVM.door=bitItem=='1' ? true : false  ;
       if(i==2) statusNotiVM.trunk=bitItem=='1' ? true : false  ;
       if(i==3) statusNotiVM.hood=bitItem=='1' ? true : false  ;
       if(i==4) statusNotiVM.engine=bitItem=='1' ? true : false  ;
       if(i==5) statusNotiVM.ignitionStatus=bitItem=='1' ? true : false  ;
       if(i==6) statusNotiVM.manualTransmission=bitItem=='1' ? true : false  ;
       //if(i==7) statusNotiVM.arm=bitItem=='1' ? true : false  ;
     }
   }

 static decodeStatus2(String statusBits) {
   for(var i=0;i<statusBits.length;i++) {
     String bitItem = statusBits.substring(i,i);
    // if(i==0) statusNotiVM.arm=bitItem=='1' ? true : false  ;
    // if(i==1) statusNotiVM.door=bitItem=='1' ? true : false  ;
     if(i==2) statusNotiVM.parkingLights=bitItem=='1' ? true : false  ;
    /* if(i==3) statusNotiVM.hood=bitItem=='1' ? true : false  ;
     if(i==4) statusNotiVM.engine=bitItem=='1' ? true : false  ;
     if(i==5) statusNotiVM.ignitionStatus=bitItem=='1' ? true : false  ;
     if(i==6) statusNotiVM.manualTransmission=bitItem=='1' ? true : false  ;*/
     //if(i==7) statusNotiVM.arm=bitItem=='1' ? true : false  ;
   }
 }

 static decodeStatus3(String statusBits) {
   for(var i=0;i<statusBits.length;i++) {
     String bitItem = statusBits.substring(i,i);
    /* if(i==0) statusNotiVM.arm=bitItem=='1' ? true : false  ;
     if(i==1) statusNotiVM.door=bitItem=='1' ? true : false  ;*/
     if(i==2) statusNotiVM.manual=bitItem=='1' ? true : false  ;
    /* if(i==3) statusNotiVM.hood=bitItem=='1' ? true : false  ;
     if(i==4) statusNotiVM.engine=bitItem=='1' ? true : false  ;
     if(i==5) statusNotiVM.ignitionStatus=bitItem=='1' ? true : false  ;
     if(i==6) statusNotiVM.manualTransmission=bitItem=='1' ? true : false  ;*/
     //if(i==7) statusNotiVM.arm=bitItem=='1' ? true : false  ;
   }
 }

 static decodeFeature1(String statusBits) {
   for(var i=0;i<statusBits.length;i++) {
     String bitItem = statusBits.substring(i,i);
      if(i==0) statusNotiVM.timerStart=bitItem=='1' ? true : false  ;
     if(i==1) statusNotiVM.siren=bitItem=='1' ? true : false  ;
     if(i==2) statusNotiVM.shockSensor=bitItem=='1' ? true : false  ;
      if(i==3) statusNotiVM.turbo=bitItem=='1' ? true : false  ;
     if(i==4) statusNotiVM.passiveArming=bitItem=='1' ? true : false  ;
     if(i==5) statusNotiVM.valet=bitItem=='1' ? true : false  ;
     //if(i==6) statusNotiVM.manualTransmission=bitItem=='1' ? true : false  ;
     if(i==7) statusNotiVM.driveLocked=bitItem=='1' ? true : false  ;
   }
 }
 static decodeFeature2(String statusBits) {
   for(var i=0;i<statusBits.length;i++) {
     String bitItem = statusBits.substring(i,i);
     //if(i==0) statusNotiVM.arm=bitItem=='1' ? true : false  ;
     if(i==1) statusNotiVM.lowBattery=bitItem=='1' ? true : false  ;
   /*  if(i==2) statusNotiVM.manual=bitItem=='1' ? true : false  ;
      if(i==3) statusNotiVM.hood=bitItem=='1' ? true : false  ;
     if(i==4) statusNotiVM.engine=bitItem=='1' ? true : false  ;
     if(i==5) statusNotiVM.ignitionStatus=bitItem=='1' ? true : false  ;
     if(i==6) statusNotiVM.manualTransmission=bitItem=='1' ? true : false  ;*/
     //if(i==7) statusNotiVM.arm=bitItem=='1' ? true : false  ;
   }
 }
 static decodeFeature3(String statusBits) {

     String bitItem1 = statusBits.substring(0,0);
     String bitItem2 = statusBits.substring(1,1);
     if(bitItem1=='0' && bitItem2=='0')
       statusNotiVM.minuteTurbo=0;
     if(bitItem1=='1' && bitItem2=='0')
       statusNotiVM.minuteTurbo=2;
     if(bitItem1=='0' && bitItem2=='1')
       statusNotiVM.minuteTurbo=1;

      bitItem1 = statusBits.substring(2,2);
      bitItem2 = statusBits.substring(3,3);

     if(bitItem1=='0' && bitItem2=='0')
       statusNotiVM.lowBatteryStartValue=0;
     if(bitItem1=='1' && bitItem2=='0')
       statusNotiVM.lowBatteryStartValue=11.5;
     if(bitItem1=='0' && bitItem2=='1')
       statusNotiVM.lowBatteryStartValue=12;
     if(bitItem1=='1' && bitItem2=='1')
       statusNotiVM.lowBatteryStartValue=12.3;

     bitItem1 = statusBits.substring(4,4);
     bitItem2 = statusBits.substring(5,5);
     if(bitItem1=='0' && bitItem2=='0')
       statusNotiVM.startEngineMinute=0;
     if(bitItem1=='1' && bitItem2=='0')
       statusNotiVM.startEngineMinute=25;
     if(bitItem1=='0' && bitItem2=='1')
       statusNotiVM.startEngineMinute=3;
     if(bitItem1=='1' && bitItem2=='1')
       statusNotiVM.startEngineMinute=5;


     bitItem1 = statusBits.substring(6,6);
     bitItem2 = statusBits.substring(7,7);
     if(bitItem1=='0' && bitItem2=='0')
       statusNotiVM.coldStart=0;
     if(bitItem1=='1' && bitItem2=='0')
       statusNotiVM.startEngineMinute=0;
     if(bitItem1=='0' && bitItem2=='1')
       statusNotiVM.startEngineMinute=-5;
     if(bitItem1=='1' && bitItem2=='1')
       statusNotiVM.startEngineMinute=-10;
 }

 static decodeData6(String data){
   statusNotiVM.temp=int.tryParse(data);
 }
 static decodeData7(String data){
   statusNotiVM.batteryValue=int.tryParse(data);
 }

  StatusNotiVM analyzeStatusNoti() {
   double notiItemSize=(noti.length / 8);
   //int notiSize=noti.length;
   if(notiItemSize!=null &&notiItemSize>0)
     {
       for(var i=0;i<notiItemSize;i++) {
           String statusTemp=noti.substring(i*8,((i+1)*8-1));
           decodeStatus(statusTemp, i);
         }
       return statusNotiVM;
     }
   return null;
 }
  analyzeNoti() {
    var notiItem=noti.split(',');
    if(notiItem!=null && notiItem.length>0)
      {
       // CarStateVM carStateVM=centerRepository.getCarStateVMByCarId(carId);

        for(var nt in notiItem)
          {
            int not=int.tryParse(nt);
            if(ActionsCommand.actionCommandsNotiMap.containsKey(not))
              {
                if(ActionsCommand.actionCommandsNotiMap.containsValue(ActionsCommand.OPEN_DOOR_VALUE_TAG) &&
                !ActionsCommand.actionCommandsNotiMap.containsValue(ActionsCommand.OPEN_TRUNK_VALUE_TAG)) {
                  if (carNotiMap.containsKey(carEnum.CarStatus.ONLYDOOROPEN)) {
                    carNotiMap.update(
                        carEnum.CarStatus.ONLYDOOROPEN, (value) => carEnum
                        .CarStatus.ONLYDOOROPEN.index);
                    carNotiMap2.update(
                        carEnum.CarStatus.ONLYDOOROPEN, (value) => true);
                  } else {
                    carNotiMap.putIfAbsent(
                        carEnum.CarStatus.ONLYDOOROPEN, () =>
                    carEnum.CarStatus.ONLYDOOROPEN.index);
                    carNotiMap2.putIfAbsent(
                        carEnum.CarStatus.ONLYDOOROPEN, () => true);
                  }
                  if (carNotiMap.containsKey(carEnum.CarStatus.ONLYTRUNKOPEN)) {
                    carNotiMap.update(
                        carEnum.CarStatus.ONLYTRUNKOPEN, (value) =>
                    carEnum.CarStatus.ONLYTRUNKOPEN.index);
                    carNotiMap2.update(
                        carEnum.CarStatus.ONLYTRUNKOPEN, (value) => false);
                  } else {
                    carNotiMap.putIfAbsent(
                        carEnum.CarStatus.ONLYTRUNKOPEN, () =>
                    carEnum.CarStatus.ONLYTRUNKOPEN.index);
                    carNotiMap2.putIfAbsent(
                        carEnum.CarStatus.ONLYTRUNKOPEN, () => false);
                  }
                }
                if(!ActionsCommand.actionCommandsNotiMap.containsValue(ActionsCommand.OPEN_DOOR_VALUE_TAG) &&
                    ActionsCommand.actionCommandsNotiMap.containsValue(ActionsCommand.OPEN_TRUNK_VALUE_TAG)){


                  if (carNotiMap.containsKey(carEnum.CarStatus.ONLYTRUNKOPEN)) {
                    carNotiMap.update(
                        carEnum.CarStatus.ONLYTRUNKOPEN, (value) =>
                    carEnum.CarStatus.ONLYTRUNKOPEN.index);
                    carNotiMap2.update(
                        carEnum.CarStatus.ONLYTRUNKOPEN, (value) => true);
                  }else
                    {
                      carNotiMap.putIfAbsent(
                          carEnum.CarStatus.ONLYTRUNKOPEN, () =>
                      carEnum.CarStatus.ONLYTRUNKOPEN.index);
                      carNotiMap2.putIfAbsent(
                          carEnum.CarStatus.ONLYTRUNKOPEN, () => true);
                    }

                  if (carNotiMap.containsKey(carEnum.CarStatus.ONLYDOOROPEN)) {
                    carNotiMap.update(
                        carEnum.CarStatus.ONLYDOOROPEN, (value) =>
                    carEnum.CarStatus.ONLYDOOROPEN.index);
                    carNotiMap2.update(
                        carEnum.CarStatus.ONLYDOOROPEN, (value) => false);
                  }
                  else
                    {
                      carNotiMap.putIfAbsent(
                          carEnum.CarStatus.ONLYDOOROPEN, () =>
                      carEnum.CarStatus.ONLYDOOROPEN.index);
                      carNotiMap2.putIfAbsent(
                          carEnum.CarStatus.ONLYDOOROPEN, () => false);
                    }
                }

                if(ActionsCommand.actionCommandsNotiMap.containsValue(ActionsCommand.OPEN_DOOR_VALUE_TAG) &&
                    ActionsCommand.actionCommandsNotiMap.containsValue(ActionsCommand.OPEN_TRUNK_VALUE_TAG)) {

                  if (carNotiMap.containsKey(carEnum.CarStatus.BOTHOPEN)) {
                    carNotiMap.update(
                        carEnum.CarStatus.BOTHOPEN, (value) =>
                    carEnum.CarStatus.BOTHOPEN.index);
                    carNotiMap2.update(
                        carEnum.CarStatus.BOTHOPEN,( value) => true);
                  }
                  else{
                    carNotiMap.putIfAbsent(
                        carEnum.CarStatus.BOTHOPEN, () =>
                    carEnum.CarStatus.BOTHOPEN.index);
                    carNotiMap2.putIfAbsent(
                        carEnum.CarStatus.BOTHOPEN, () => true);
                  }

                }
              }
          }
      }
  }


}
