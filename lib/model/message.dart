import 'package:anad_magicar/model/viewmodel/car_state.dart';

class Message {
   String text;
   String type;
   int index;
   CarStateVM currentCarState;
  bool status=false;
  Message({this.text, this.type,this.status,this.index,this.currentCarState});
}