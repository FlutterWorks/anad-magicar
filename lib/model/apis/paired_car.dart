import 'package:flutter/material.dart';

class ApiPairedCar {

  int MasterCarId;
  List<int> CarIds=new List();

  ApiPairedCar({
    @required this.MasterCarId,
    @required this.CarIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'MasterCarId': this.MasterCarId,
      'CarIds': this.CarIds,
    };
  }

  factory ApiPairedCar.fromMap(Map<String, dynamic> map) {

    return new ApiPairedCar(
      MasterCarId: map['MasterCarId'] ,
      CarIds: map['CarIds'] ,
    );
  }

  factory ApiPairedCar.fromJson(Map<String, dynamic> json) {
    return ApiPairedCar(MasterCarId: int.parse(json["MasterCarId"]),
      CarIds: List.of(json["CarIds"]).map((i) => int.parse(i)).toList(),);
  }

  Map<String, dynamic> toJsonForDeletePairedCars() {
    return {"MasterCarId": this.MasterCarId, "CarIds": this.CarIds.map<int>((i)=>i).toList(),};
  }


}
