import 'package:flutter/material.dart';

class ApiRoute {

  int carId;
  String startDate;
  String endDate;
  String dateTime;
  int speed;
  String lat;
  String long;
  String enterTime;

  List<int> carIds;


  //int CarId
  int DeviceId;
  String Latitude;
  String Longitude;
  //Int Speed
  String Date;
  String Time;
  String CreatedDateTime;


  ApiRoute({
    @required this.carId,
    @required this.startDate,
    @required this.endDate,
    @required this.dateTime,
    @required this.speed,
    @required this.lat,
    @required this.long,
    @required this.enterTime,
    @required this.carIds,
    @required this.DeviceId,
    @required this.Latitude,
    @required this.Longitude,
    @required this.Date,
    @required this.Time,
    @required this.CreatedDateTime,
  });


  factory ApiRoute.fromJson(Map<String, dynamic> json) {
    return ApiRoute(carId: json["CarId"],
      startDate: json["StartDate"],
      endDate: json["EndDate"],);
  }

  Map<String, dynamic> toJson() {
    return {
      "CarId": this.carId,
      "StartDate": this.startDate,
      "EndDate": this.endDate,
    };
  }
  Map<String, dynamic> toJsonLastPosition() {
    return {
      "CarIds": this.carIds.map<int>((c)=> c).toList(),
    };
  }

  Map<String, dynamic> toMapResult() {
    return {
      'DateTime': this.dateTime,
      'Speed': this.speed,
      'Latitude': this.lat,
      'Longitude': this.long,
      'EnterTime': this.enterTime,
    };
  }

  Map<String, dynamic> toMapLastPositionResult() {
    return {
      'CarId':this.carId,
      'DeviceId': this.DeviceId,
      'Time':this.Time,
      'Date': this.Date,
      'Speed': this.speed,
      'Latitude': this.lat,
      'Longitude': this.long,
      'CreatedDateTime': this.enterTime,
    };
  }
  factory ApiRoute.fromMapResult(Map<String, dynamic> map) {
    return new ApiRoute(
      dateTime: map['DateTime'] ,
      speed: map['Speed'] ,
      lat: map['Latitude'] ,
      long: map['Longitude'] ,
      enterTime: map['EnterTime'] ,
    );
  }
  factory ApiRoute.fromMapLastPositionResult(Map<String, dynamic> map) {
    return new ApiRoute(
      dateTime: map['Date'] ,
      speed: map['Speed'] ,
      Latitude: map['Latitude'] ,
      Longitude: map['Longitude'] ,
      Time: map['Time'] ,
      Date: map['Date'],
      DeviceId: map['DeviceId'],
      CreatedDateTime: map['CreatedDateTime'],
      carId: map['CarId']
    );
  }

  factory ApiRoute.fromJsonResult(Map<String, dynamic> json) {
   /* String llat=json["Latitude"];
    String llng=json["Longitude"];

    llat=llat.replaceAll('"', '');
    llat=llat.replaceAll('.', '');
    llat=llat.replaceAll('*', '.');

    llng=llng.replaceAll('"', '');
    llng=llng.replaceAll('.', '');
    llng=llng.replaceAll('*', '.');*/
    return ApiRoute(dateTime: json["DateTime"],
      speed: json["Speed"],
      lat:json["Latitude"] ,
      long: json["Longitude"],
      enterTime: json["EnterTime"],);
  }
  factory ApiRoute.fromJsonLastPositionResult(Map<String, dynamic> json) {
   /* String llat=json["Latitude"];
    String llng=json["Longitude"];

    llat=llat.replaceAll('"', '');
    llat=llat.replaceAll('.', '');
    llat=llat.replaceAll('*', '.');

    llng=llng.replaceAll('"', '');
    llng=llng.replaceAll('.', '');
    llng=llng.replaceAll('*', '.');*/
    return ApiRoute(Date: json["Date"],
      speed: json["Speed"],
      Latitude:json["Latitude"],
      Longitude: json["Longitude"],
      Time: json["Time"],
    carId: json["CarId"],
    DeviceId: json["DeviceId"],
      CreatedDateTime: json["CreatedDateTime"],

    );
  }

  Map<String, dynamic> toJsonForFetchOpenRouteService() {
    return {
      "Latitude": this.lat,
      "Longitude": this.long,
    };
  }

  Map<String, dynamic> toJsonResult() {
    return {
      "DateTime": this.dateTime,
      "Speed": this.speed,
      "Latitude": this.lat,
      "Longitude": this.long,
      "EnterTime": this.enterTime,
    };
  }
  Map<String, dynamic> toJsonLastPositionResult() {
    return {
      "CarId": this.carId,
      "Time": this.Time,
      "Date": this.Date,
      "DeviceId": this.DeviceId,
      "Speed": this.speed,
      "Latitude": this.Longitude,
      "Longitude": this.Longitude,
      "CreatedDateTime": this.CreatedDateTime,
    };
  }
  Map<String, dynamic> toMap() {
    return {
      'CarId': this.carId,
      'StartDate': this.startDate,
      'EndDate': this.endDate,
    };
  }

  factory ApiRoute.fromMap(Map<String, dynamic> map) {
    return new ApiRoute(
      carId: map['CarId'] ,
      startDate: map['StartDate'] ,
      endDate: map['EndDate'] ,
    );
  }



}
