import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/components/flutter_form_builder/flutter_form_builder.dart';
import 'package:anad_magicar/components/send_data.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_message.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/base/main_page.dart';
import 'package:anad_magicar/ui/screen/message_app/message_app_form.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/widgets/animated_dialog_box.dart';

class MessageAppPage extends StatefulWidget {
  MessageAppPage({Key key}) : super(key: key);

  @override
  MessageAppPageState createState() {
    return MessageAppPageState();
  }
}

class MessageAppPageState extends MainPage<MessageAppPage> {

 static final String route='/messageapp';
 final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
 bool _autoValidate=false;
 ApiMessage newMessage;
 String messageBody='';
 String messageSubject='';


 _onMessageSubjectChanged(String value){
   messageSubject=value;
 }

 _onMessageBodyChanged(String value){
   messageBody=value;
 }

 sendMessage(BuildContext context) async {
   await animated_dialog_box.showScaleAlertBox(
       title:Center(child: Text(Translations.current.sendMessage())) ,
       context: context,
       firstButton: MaterialButton(
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(40),
         ),
         color: Colors.white,
         child: Text(Translations.current.send()),
         onPressed: () {
          sendNewMessage();
         },
       ),
       secondButton: MaterialButton(
         // OPTIONAL BUTTON
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(40),
         ),
         color: Colors.white,
         child: Text(Translations.current.cancel()),
         onPressed: () {

           Navigator.of(context).pop();
         },
       ),
       icon: Icon(Icons.message,color: Colors.indigoAccent,),
       yourWidget:
             new ListView (
               physics: BouncingScrollPhysics(),
               children: <Widget>[
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.center,
                   //margin: EdgeInsets.symmetric(horizontal: 20.0),
                   children: <Widget>[
                     SizedBox(
                       height: 0,
                     ),

                     Container(
                       margin: EdgeInsets.symmetric(horizontal: 12.0),
                       width:MediaQuery.of(context).size.width*0.60,
                       child:
                       Form(
                         key: _formKey,
                         autovalidate: _autoValidate,
                         child:
                         SingleChildScrollView(
                           scrollDirection: Axis.vertical,
                           physics: BouncingScrollPhysics(),
                           child: new Column(
                             children: <Widget>[

                               Container(
                                 //height: 45,
                                 padding: EdgeInsets.symmetric(
                                     vertical: 2.0, horizontal: 2.0),
                                 child:
                                 FormBuilderTextField(
                                   initialValue: '',
                                   attribute: "MessageSubject",
                                   decoration: InputDecoration(
                                     labelText: Translations.current.messageSubject(),
                                   ),
                                   onChanged: (value) => _onMessageSubjectChanged(value),
                                   valueTransformer: (text) => text,
                                   validators: [
                                     FormBuilderValidators.required(),
                                   ],
                                   keyboardType: TextInputType.text,
                                 ),

                               ),
                               Container(
                                 // height: 45,
                                 padding: EdgeInsets.symmetric(
                                     vertical: 2.0, horizontal: 2.0),
                                 child:
                                 FormBuilderTextField(
                                   initialValue: '',
                                   attribute: "MessageBody",
                                   decoration: InputDecoration(
                                     labelText: Translations.current.messageBody(),
                                   ),
                                   onChanged: (value) => _onMessageBodyChanged(value),
                                   valueTransformer: (text) => text,
                                   validators: [
                                     FormBuilderValidators.required(),
                                   ],
                                   keyboardType: TextInputType.text,
                                 ),
                               ),



                               new GestureDetector(
                                 onTap: () {
                                   sendNewMessage();
                                 },
                                 child:
                                 Container(

                                   child:
                                   new SendData(),
                                 ),
                               ),
                               new GestureDetector(
                                 onTap: () {
                                   Navigator.pop(context);
                                 },
                                 child:
                                 Container(
                                   width: 100.0,
                                   height: 60.0,
                                   child:
                                   new Button(title: Translations.current.cancel(),
                                     color: Colors.white.value,
                                     clr: Colors.amber,),
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ),
                     ),
                   ],
                 ),
               ],
             ),
       );
 }

 _showBottomSheetPlans(BuildContext cntext,)
 {
   showModalBottomSheetCustom(context: cntext ,
       builder: (BuildContext context) {
         return Container(
           width: 350.0,
           height: 300,
           child:
           Stack(
             children: <Widget>[
               new ListView (
                 physics: BouncingScrollPhysics(),
                 children: <Widget>[
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                     //margin: EdgeInsets.symmetric(horizontal: 20.0),
                     children: <Widget>[
                       SizedBox(
                         height: 0,
                       ),

                       Container(
                         margin: EdgeInsets.symmetric(horizontal: 12.0),
                         width:MediaQuery.of(context).size.width*0.60,
                         child:
                         Form(
                           key: _formKey,
                           autovalidate: _autoValidate,
                           child:
                           SingleChildScrollView(
                             scrollDirection: Axis.vertical,
                             physics: BouncingScrollPhysics(),
                             child: new Column(
                               children: <Widget>[

                                 Container(
                                   //height: 45,
                                   padding: EdgeInsets.symmetric(
                                       vertical: 2.0, horizontal: 2.0),
                                   child:
                                   FormBuilderTextField(
                                     initialValue: '',
                                     attribute: "MessageSubject",
                                     decoration: InputDecoration(
                                       labelText: Translations.current.messageSubject(),
                                     ),
                                     onChanged: (value) => _onMessageSubjectChanged(value),
                                     valueTransformer: (text) => text,
                                     validators: [
                                       FormBuilderValidators.required(),
                                     ],
                                     keyboardType: TextInputType.text,
                                   ),

                                 ),
                                 Container(
                                   // height: 45,
                                   padding: EdgeInsets.symmetric(
                                       vertical: 2.0, horizontal: 2.0),
                                   child:
                                   FormBuilderTextField(
                                     initialValue: '',
                                     attribute: "MessageBody",
                                     decoration: InputDecoration(
                                       labelText: Translations.current.messageBody(),
                                     ),
                                     onChanged: (value) => _onMessageBodyChanged(value),
                                     valueTransformer: (text) => text,
                                     validators: [
                                       FormBuilderValidators.required(),
                                     ],
                                     keyboardType: TextInputType.text,
                                   ),
                                 ),



                                 new GestureDetector(
                                   onTap: () {
                                      sendNewMessage();
                                   },
                                   child:
                                   Container(

                                     child:
                                     new SendData(),
                                   ),
                                 ),
                                 new GestureDetector(
                                   onTap: () {
                                     Navigator.pop(context);
                                   },
                                   child:
                                   Container(
                                     width: 100.0,
                                     height: 60.0,
                                     child:
                                     new Button(title: Translations.current.cancel(),
                                       color: Colors.white.value,
                                       clr: Colors.amber,),
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ),
                       ),
                     ],
                   ),
                 ],
               ),


             ],
           ),
         );
       });
 }


 sendNewMessage() async{
   newMessage=new ApiMessage(MessageId: null, MessageBody: messageBody,
       MessageDate: DateTime.now().toString(), Description: null, MessageSubject: messageSubject,
       MessageStatusConstId: ApiMessage.MESSAGE_STATUS_AS_INSERT_TAG);
   var result=await restDatasource.sendMessage(newMessage);
   if(result!=null )
     {
       if(result.IsSuccessful){
         Navigator.pop(context);
         centerRepository.showFancyToast(Translations.current.messageHasSentSuccessfull());
       }
       else{
         Navigator.pop(context);
         centerRepository.showFancyToast(Translations.current.messageSentUnSuccessfull());
       }
     }
 }
  @override
  void dispose() {
    super.dispose();
  }



  @override
  List<Widget> actionIcons() {
    // TODO: implement actionIcons
    return null;
  }

  @override
  String getCurrentRoute() {
    // TODO: implement getCurrentRoute
    return route;
  }

  @override
  FloatingActionButton getFab() {
    // TODO: implement getFab
    return FloatingActionButton(
      onPressed: (){ sendMessage(context); },
      child: Icon(Icons.add,color: Colors.white,
        size: 30.0,),
      backgroundColor: Colors.blueAccent,
      elevation: 0.0,

    );
  }

  @override
  initialize() {
    // TODO: implement initialize
    return null;
  }

  @override
  Widget pageContent() {
    // TODO: implement pageContent
    return new MessageAppForm();
  }

  @override
  int setCurrentTab() {
    // TODO: implement setCurrentTab
    return 2;
  }
}
