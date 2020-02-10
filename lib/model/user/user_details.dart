import 'dart:core';

import 'package:flutter/material.dart';

class UserDetails {
  int id;
  String firstName;
  String lastName;
  String phone;
  String mobile;
  String age;
  String nationCode;
  String address;
  bool gender;

  UserDetails({
    @required this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.phone,
    @required this.mobile,
    @required this.age,
    @required this.nationCode,
    @required this.address,
    @required this.gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'Id':this.id,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'phone': this.phone,
      'mobile': this.mobile,
      'age': this.age,
      'nationCode': this.nationCode,
      'address': this.address,
      'gender': this.gender,
    };
  }

  factory UserDetails.fromMap(Map<String, dynamic> map) {
    return new UserDetails(
      id: map['Id'],
      firstName: map['firstName'] ,
      lastName: map['lastName'] ,
      phone: map['phone'] ,
      mobile: map['mobile'] ,
      age: map['age'] ,
      nationCode: map['nationCode'] ,
      address: map['address'] ,
      gender: map['gender'] ,
    );
  }

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
    id:json["Id"],
        firstName: json["firstName"],
      lastName: json["lastName"],
      phone: json["phone"],
      mobile: json["mobile"],
      age: json["age"],
      nationCode: json["nationCode"],
      address: json["address"],
      gender: json["gender"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "Id":this.id,
      "firstName": this.firstName,
      "lastName": this.lastName,
      "phone": this.phone,
      "mobile": this.mobile,
      "age": this.age,
      "nationCode": this.nationCode,
      "address": this.address,
      "gender": this.gender,
    };
  }


}
