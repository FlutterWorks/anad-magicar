import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/date/helper/shamsi_date.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/base/main_page.dart';
import 'package:anad_magicar/ui/screen/message/message_history_form.dart';
import 'package:anad_magicar/utils/date_utils.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:anad_magicar/widgets/persian_datepicker/persian_datepicker.dart';
import 'package:flutter/material.dart';


class MessageHistoryScreen extends StatefulWidget {
  int carId;
  MessageHistoryScreen({Key key,this.carId}) : super(key: key);

  @override
  MessageHistoryScreenState createState() {
    return MessageHistoryScreenState();
  }
}

class MessageHistoryScreenState extends MainPage<MessageHistoryScreen> {

  final TextEditingController textEditingController = TextEditingController();
  String fromDate='';
  String toDate='';
  PersianDatePickerWidget persianDatePicker;
  NotyBloc<ChangeEvent> notyDateFilterBloc;
  NotyBloc<ChangeEvent> notyDateSelectedBloc;


  initDatePicker(TextEditingController controller,String type){
    persianDatePicker = PersianDatePicker(
      controller: controller,
      datetime: Jalali.now().toString(),
      fontFamily: 'IranSans',
      onChange: (String oldText, String newText){
        if(type=='From')
          fromDate=newText;
        else
          toDate=newText;
      },

    ).init();
    return persianDatePicker;
  }
  _showBottomSheetDates(BuildContext cntext)
  {
    showModalBottomSheetCustom(context: cntext ,
        mHeight: 0.95,
        builder: (BuildContext context) {
          return
            Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(Translations.current.fromDate(),
              style: TextStyle(color: Colors.pinkAccent,fontSize: 15.0),
              textAlign: TextAlign.center,),
            Container(
              height: MediaQuery.of(context).size.height*0.35,
              child: initDatePicker(textEditingController, 'From'),
            ),
            Text(Translations.current.toDate(),
              style: TextStyle(color: Colors.pinkAccent,fontSize: 15.0),
              textAlign: TextAlign.center,),
            Container(
              height:MediaQuery.of(context).size.height*0.35,
              child: initDatePicker(textEditingController, 'To'),
            ),
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          FlatButton(
          child: Button(wid: 140.0,color: Colors.pinkAccent.value,title: Translations.current.doFilter(),),
          onPressed: () {
          notyDateFilterBloc.updateValue(new ChangeEvent(fromDate: fromDate,toDate: toDate));
          Navigator.pop(context);

          },
          )
          ],
          )
          ],
          );
        });

  }
  showFilterDate(BuildContext context, bool from) {

    return _showBottomSheetDates(context);
  }




  @override
  void dispose() {
    notyDateFilterBloc.dispose();
    notyDateSelectedBloc.dispose();
    super.dispose();
  }



  @override
  List<Widget> actionIcons() {
    List<Widget> actions=[


      IconButton(
        icon: Icon(Icons.date_range,color: Colors.indigoAccent,),
        onPressed: (){
          showFilterDate(context, true);
        },
      ),
    IconButton(
        icon: Icon(Icons.arrow_forward,color: Colors.indigoAccent,),
        onPressed: (){
          Navigator.pushNamed(context, '/home');
        },
      ),
    ];
    return actions;
  }

  @override
  String getCurrentRoute() {
    // TODO: implement getCurrentRoute
    return '/messages';
  }

  @override
  FloatingActionButton getFab() {
    // TODO: implement getFab
    return null;
  }

  @override
  initialize() {
    // TODO: implement initialize
    persianDatePicker = PersianDatePicker(
      controller: textEditingController,
      datetime: Jalali.now().toString(),
      fontFamily: 'IranSans',
      onChange: (String oldText,String nexText){

      }
    ).init();
    notyDateFilterBloc=new NotyBloc<ChangeEvent>();
    notyDateSelectedBloc=new NotyBloc<ChangeEvent>();
   /* fromDate=Jalali.now().addDays(-3).toString();
    notyDateFilterBloc.updateValue(new ChangeEvent(fromDate:fromDate,toDate: Jalali.now().toString() ));*/
    return null;
  }

  @override
  Widget pageContent() {
    // TODO: implement pageContent
    return new MessageHistoryForm(carId: widget.carId,notyDateFilterBloc: notyDateFilterBloc,);
  }

  @override
  int setCurrentTab() {
    // TODO: implement setCurrentTab
    return 3;
  }
}
