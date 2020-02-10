import 'package:anad_magicar/model/apis/api_service.dart';
import 'package:flutter/material.dart';

class ServiceVM {
  int carId;
  bool editMode;
  ApiService service;

  ServiceVM({
    @required this.carId,
    @required this.editMode,
    @required this.service,
  });

}
