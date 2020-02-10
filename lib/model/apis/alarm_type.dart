import 'package:flutter/material.dart';

class AlarmType {
  int AlarmTypeId;
  String AlarmTypeCode;
  String AlarmTypeTitle;
  bool IsDefault;
  int ActionId;
  String Description;
  String CreatedDate;
  String LastUpdateDate;

  AlarmType({
    @required this.AlarmTypeId,
    @required this.AlarmTypeCode,
    @required this.AlarmTypeTitle,
    @required this.IsDefault,
    @required this.ActionId,
    @required this.Description,
    @required this.CreatedDate,
    @required this.LastUpdateDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'AlarmTypeId': this.AlarmTypeId,
      'AlarmTypeCode': this.AlarmTypeCode,
      'AlarmTypeTitle': this.AlarmTypeTitle,
      'IsDefault': this.IsDefault,
      'ActionId': this.ActionId,
      'Description': this.Description,
      'CreatedDate': this.CreatedDate,
      'LastUpdateDate': this.LastUpdateDate,
    };
  }

  factory AlarmType.fromMap(Map<String, dynamic> map) {
    return new AlarmType(
      AlarmTypeId: map['AlarmTypeId'] as int,
      AlarmTypeCode: map['AlarmTypeCode'] as String,
      AlarmTypeTitle: map['AlarmTypeTitle'] as String,
      IsDefault: map['IsDefault'] as bool,
      ActionId: map['ActionId'] as int,
      Description: map['Description'] as String,
      CreatedDate: map['CreatedDate'] as String,
      LastUpdateDate: map['LastUpdateDate'] as String,
    );
  }

  factory AlarmType.fromJson(Map<String, dynamic> json) {
    return AlarmType(AlarmTypeId: int.parse(json["AlarmTypeId"]),
      AlarmTypeCode: json["AlarmTypeCode"],
      AlarmTypeTitle: json["AlarmTypeTitle"],
      IsDefault: json["IsDefault"].toLowerCase() == 'true',
      ActionId: int.parse(json["ActionId"]),
      Description: json["Description"],
      CreatedDate: json["CreatedDate"],
      LastUpdateDate: json["LastUpdateDate"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "AlarmTypeId": this.AlarmTypeId,
      "AlarmTypeCode": this.AlarmTypeCode,
      "AlarmTypeTitle": this.AlarmTypeTitle,
      "IsDefault": this.IsDefault,
      "ActionId": this.ActionId,
      "Description": this.Description,
      "CreatedDate": this.CreatedDate,
      "LastUpdateDate": this.LastUpdateDate,
    };
  }


}
