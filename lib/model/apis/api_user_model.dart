import 'package:flutter/material.dart';

class SaveUserModel {
  String UserName;
  String FirstName;
  String LastName;
  String MobileNo;
  String Password;
  String SimCard;
  int UserId;
  String code;
  String currentPassword;
  String newPassword;
  String confirmNewPassword;

  bool isSuccess=true;
  String errorMessage='';
  SaveUserModel({
    @required this.UserName,
    @required this.FirstName,
    @required this.LastName,
    @required this.MobileNo,
    @required this.Password,
    @required this.SimCard,
    @required this.UserId,
    this.code,
    this.currentPassword,
    this.newPassword,
    this.confirmNewPassword
  });

  Map<String, dynamic> toMap() {
    return {
      'UserName': this.UserName,
      'FirstName': this.FirstName,
      'LastName': this.LastName,
      'MobileNo': this.MobileNo,
      'Password': this.Password,
    };
  }
  Map<String, dynamic> toMapForResetPassword() {
    return {
      'currentPassword': this.Password,
      'newPassword': this.newPassword,
      'confirmNewPassword': this.confirmNewPassword,
    };
  }
  Map<String, dynamic> toMapForSMSValidation() {
    return {
      'userId': this.UserId,
      'code': this.code,
    };
  }

  Map<String, dynamic> toMapForLogin() {
    return {
      'UserName': this.UserName,
      'Password': this.Password,
    };
  }
  Map<String, dynamic> toMapForGetUserInfo() {
    return {
      'userId': this.UserId,
    };
  }
  Map<String, dynamic> toMapForUserInfo() {
    return {
      'UserName': this.UserName,
      'FirstName': this.FirstName,
      'LastName': this.LastName,
      'SimCard': this.SimCard,
      'Password': this.Password,
    };
  }
  factory SaveUserModel.fromMap(Map<String, dynamic> map) {
    return new SaveUserModel(
      UserName: map['UserName'] ,
      FirstName: map['FirstName'],
      LastName: map['LastName'] ,
      MobileNo: map['MobileNo'] ,
      Password: map['Password'] ,
    );
  }

  factory SaveUserModel.fromMapForResultUserInfo(Map<String, dynamic> map) {
    return new SaveUserModel(
      UserId: map['UserId'],
      UserName: map['UserName'] ,
      FirstName: map['FirstName'],
      LastName: map['LastName'] ,
      SimCard: map['SimCard'] ,
      Password: map['Password'] ,
    );
  }
  factory SaveUserModel.fromJson(Map<String, dynamic> json) {
    return SaveUserModel(
      UserId: json["UserId"],
      UserName: json["UserName"],
      FirstName: json["FirstName"],
      LastName: json["LastName"],
      MobileNo: json["MobileNo"],
      Password: json["Password"],);
  }
  factory SaveUserModel.fromJsonForResultUserInfo(Map<String, dynamic> json) {
    return SaveUserModel(
      UserId: json["UserId"],
      UserName: json["UserName"],
      FirstName: json["FirstName"],
      LastName: json["LastName"],
      MobileNo: json["SimCard"],
      Password: json["Password"],);
  }
  Map<String, dynamic> toJson() {
    return {
      "UserName": this.UserName,
      "FirstName": this.FirstName,
      "LastName": this.LastName,
      "MobileNo": this.MobileNo,
      "Password": this.Password,
    };


  }
  Map<String, dynamic> toJsonForEdit() {
    return {
      "UserId": this.UserId,
      "FirstName": this.FirstName,
      "LastName": this.LastName,
      "MobileNo": this.MobileNo,
      //"Password": this.Password,
    };
  }
  Map<String, dynamic> toJsonForForgotPassword() {
    return {
      "UserId": this.UserId,
      "MobileNo": this.MobileNo,
      //"Password": this.Password,
    };
  }
  Map<String, dynamic> toJsonForGetUserInfo() {
    return {
      "userId": this.UserId,
    };
  }
  Map<String, dynamic> toJsonForUserInfo() {
    return {
      "UserName": this.UserName,
      "FirstName": this.FirstName,
      "LastName": this.LastName,
      "SimCard": this.SimCard,
      "Password": this.Password,
    };
  }

  Map<String, dynamic> toJsonForLogin() {
    return {
      "UserName": this.UserName,
      "Password": this.Password,
    };
  }

  Map<String, dynamic> toJsonForResetPassword() {
    return {
      "currentPassword": this.Password,
      "newPassword": this.newPassword,
      "confirmNewPassword": this.confirmNewPassword,
    };
  }

  Map<String, dynamic> toJsonForSMSValidation() {
    return {
      "userId": this.UserId,
      "code": this.code,
    };
  }
}
