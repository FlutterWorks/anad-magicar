import 'package:flutter/material.dart';

class CarActionLog {
  int CarActionLogId;
  int CarId;
  String ActionDate;
  String Latitude;
  String Logitude;
  String CostAmount;
  int PlanId;
  String PlanTitle;
  String ActionTitle;

  CarActionLog({
    @required this.CarActionLogId,
    @required this.CarId,
    @required this.ActionDate,
    @required this.Latitude,
    @required this.Logitude,
    @required this.CostAmount,
    @required this.PlanId,
    @required this.PlanTitle,
    @required this.ActionTitle,
  });

  Map<String, dynamic> toMap() {
    return {
      'CarActionLogId': this.CarActionLogId,
      'CarId': this.CarId,
      'ActionDate': this.ActionDate,
      'Latitude': this.Latitude,
      'Logitude': this.Logitude,
      'CostAmount': this.CostAmount,
      'PlanId': this.PlanId,
      'PlanTitle': this.PlanTitle,
      'ActionTitle': this.ActionTitle,
    };
  }

  factory CarActionLog.fromMap(Map<String, dynamic> map) {
    return new CarActionLog(
      CarActionLogId: map['CarActionLogId'] ,
      CarId: map['CarId'] ,
      ActionDate: map['ActionDate'] ,
      Latitude: map['Latitude'] ,
      Logitude: map['Logitude'] ,
      CostAmount: map['CostAmount'] ,
      PlanId: map['PlanId'] ,
      PlanTitle: map['PlanTitle'] ,
      ActionTitle: map['ActionTitle'] ,
    );
  }

  factory CarActionLog.fromJson(Map<String, dynamic> json) {
    return CarActionLog(CarActionLogId: json["CarActionLogId"],
      CarId: json["CarId"],
      ActionDate: json["ActionDate"],
      Latitude: json["Latitude"],
      Logitude: json["Logitude"],
      CostAmount: json["CostAmount"],
      PlanId: json["PlanId"],
      PlanTitle: json["PlanTitle"],
      ActionTitle: json["ActionTitle"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "CarActionLogId": this.CarActionLogId,
      "CarId": this.CarId,
      "ActionDate": this.ActionDate,
      "Latitude": this.Latitude,
      "Logitude": this.Logitude,
      "CostAmount": this.CostAmount,
      "PlanId": this.PlanId,
      "PlanTitle": this.PlanTitle,
      "ActionTitle": this.ActionTitle,
    };
  }


}
