import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/date/helper/shamsi_date.dart';
import 'package:anad_magicar/date/helper/src/jalali/jalali_date.dart';
import 'package:flutter/material.dart';

class ApiMessage {

  static final int MESSAGE_STATUS_AS_READ_TAG=12354;
  static final int MESSAGE_STATUS_AS_INSERT_TAG=152360;
  static final int MESSAGE_TYPE_CONST_ID_TAG=152355;

  int MessageId;
  String MessageBody;
  String MessageDate;
  String Description;
  String MessageSubject;
  int MessageStatusConstId;
  int MessageTypeConstId;
  int CarId;
  int ReceiverUserId;
  bool IsActive;
  int RowStateType;

  ApiMessage({
    @required this.MessageId,
    @required this.MessageBody,
    @required this.MessageDate,
    @required this.Description,
    @required this.MessageSubject,
    @required this.MessageStatusConstId,
  });

  Map<String, dynamic> toMap() {
    return {
      'MessageBody': this.MessageBody,
      'MessageDate': this.MessageDate,
      'Description': this.Description,
      'MessageSubject': this.MessageSubject,
      'MessageStatusConstId': this.MessageStatusConstId,
    };
  }

  factory ApiMessage.fromMap(Map<String, dynamic> map) {
    return new ApiMessage(
      MessageBody: map['MessageBody'] ,
      MessageDate: map['MessageDate'] ,
      Description: map['Description'] ,
      MessageSubject: map['MessageSubject'] ,
      MessageStatusConstId: map['MessageStatusConstId'] ,
    );
  }

  factory ApiMessage.fromJson(Map<String, dynamic> json) {
    return ApiMessage(MessageBody: json["MessageBody"],
      MessageDate: json["MessageDate"],
      Description: json["Description"],
      MessageSubject: json["MessageSubject"],
      MessageStatusConstId: json["MessageStatusConstId"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "MessageBody": this.MessageBody,
      "MessageDate": this.MessageDate,
      "Description": this.Description,
      "MessageSubject": this.MessageSubject,
      "MessageStatusConstId": this.MessageStatusConstId,
    };


  }


  Map<String, dynamic> toJsonForSendMessage() {
    return {
      "MessageBody": this.MessageBody,
      "MessageDate": this.MessageDate,
      "Description": this.Description,
      "MessageSubject": this.MessageSubject,
      "MessageStatusConstId": this.MessageStatusConstId,
      "ReceiverUserId":this.ReceiverUserId,
      "MessageTypeConstId":this.MessageTypeConstId,
      "IsActive":this.IsActive,
      "RowStateType" :Constants.ROWSTATE_TYPE_INSERT
    };


  }


  Map<String, dynamic> toJsonForEdit() {
    return {
      "MessageId": this.MessageId,
      //"MessageBody": this.MessageBody,
      //"MessageDate": this.MessageDate,
      //"Description": this.Description,
      //"MessageSubject": this.MessageSubject,
      "MessageStatusConstId": this.MessageStatusConstId,
    };

  }

  @override
  String toString() {
    DateTime messageDate=DateTime.parse(MessageDate);
    Jalali date=Jalali.fromDateTime(messageDate);
    return date.toString();
  }


}
