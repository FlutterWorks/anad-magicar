

import 'package:anad_magicar/date/helper/shamsi_date.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:intl/intl.dart';

class DateTimeUtils{

 static DateTime convertIntoDateTimeObject(String dateTime)
 {
   try {
     DateTime dateTimeObj = new DateFormat("yyyy-MM-dd hh:mm:ss", "en-US")
         .parse(dateTime);
     if (dateTimeObj != null)
       return dateTimeObj;
   }
   catch(e){
     print(e.toString());
     return null;
   }
   return null;
 }

 static double diffDaysFromDateToDate(String fromDate,String toDate)
 {
    String fromDate_temp=DartHelper.isNullOrEmptyString(fromDate);
    String toDate_temp=DartHelper.isNullOrEmptyString(toDate);
    if(fromDate_temp==null || fromDate_temp.isEmpty)
      fromDate_temp='0/0/0';
    if(toDate_temp==null || toDate_temp.isEmpty)
      toDate_temp='0/0/0';

    var fDate=fromDate_temp.split('/');
   var tDate=toDate_temp.split('/');

    int fy=int.tryParse( DartHelper.isNullOrEmpty( fDate[0]) ? 0 : fDate[0]);
    int ty=int.tryParse(DartHelper.isNullOrEmpty( tDate[0]) ? 0 : tDate[0]);

   int fm=int.tryParse( DartHelper.isNullOrEmpty( fDate[1]) ? 0 : fDate[1]);
   int tm=int.tryParse( DartHelper.isNullOrEmpty( tDate[1]) ? 0 : tDate[1]);

   int fd=int.tryParse( DartHelper.isNullOrEmpty( fDate[2]) ? 0 : fDate[2]);
   int td=int.tryParse( DartHelper.isNullOrEmpty( tDate[2]) ? 0 : tDate[2]);

   Jalali fromJ=Jalali(fy,fm,fd);
   Jalali toJ=Jalali(ty,tm,td);

   DateTime fdt= fromJ.toDateTime();
   DateTime tdt= toJ.toDateTime();

   Duration duration= fdt.difference(tdt);
   int result= duration.inDays;

   return (result / 365).roundToDouble();

 }

 static String getDateJalali(){
   Jalali fromJ=Jalali.now();
   String result=fromJ.year.toString()+'/'+fromJ.month.toString()+'/'+fromJ.day.toString();
   return result;
 }

}


DateTimeUtils dateTimeUtils=new DateTimeUtils();
