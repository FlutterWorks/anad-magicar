import 'dart:convert';

import 'package:anad_magicar/bloc/service/register.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_car_service.dart';
import 'package:anad_magicar/model/apis/api_service.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/repository/pref_repository.dart';

import 'package:flutter/material.dart';

import 'package:anad_magicar/repository/center_repository.dart';

import 'package:meta/meta.dart';


@immutable
abstract class RegisterServiceEvent {
  Future<RegisterServiceState> applyAsync(
      {RegisterServiceState currentState, RegisterCarServiceBloc bloc});

}

class UnRegisterServiceEvent extends RegisterServiceEvent{

  String token;
  String typeId;

  UnRegisterServiceEvent(this.token, this.typeId);

  @override
  Future<RegisterServiceState> applyAsync({RegisterServiceState currentState, RegisterCarServiceBloc bloc}) async{
    return UnRegisterServiceState();
  }

}

class InRegisterServiceEvent extends RegisterServiceEvent{

  String token;
  String typeId;

  InRegisterServiceEvent(this.token, this.typeId);

  @override
  Future<RegisterServiceState> applyAsync({RegisterServiceState currentState, RegisterCarServiceBloc bloc}) async{
    if(currentState is UnRegisterServiceState) {
      try {

            return new LoadRegisterServiceState();

      }

      catch (_, stackTrace) {
        return new ErrorRegisterServiceState(_?.toString());
      }
    }
    return new InRegisterServiceState();
  }

}

class LoadRegisterServiceEvent extends RegisterServiceEvent {

  User user;
  ApiService serviceModel;
  BuildContext context;
  LoadRegisterServiceEvent(this.user,this.serviceModel, this.context);

  @override
  String toString() => 'LoadRegisterServiceEvent';

  @override
  Future<RegisterServiceState> applyAsync({RegisterServiceState currentState, RegisterCarServiceBloc bloc}) async {

   try {
        if(serviceModel!=null) {
          var result = await restDatasource.saveCarService(serviceModel);
          if (result != null) {
            if (result.IsSuccessful)
              return new RegisteredServiceState();
            else
              return ErrorRegisterServiceState(result.Message);
          }
          else
            return new ErrorRegisterServiceState('خطا در ثبت سرویس خودرو');
        }
    } catch (_, stackTrace) {
      return new ErrorRegisterServiceState(_?.toString());
    }
  }
}

class RegisteredServiceEvent extends RegisterServiceEvent {
  User user;

  RegisteredServiceEvent({this.user});
  @override
  String toString() => 'RegisteredServiceEvent';

  @override
  Future<RegisterServiceState> applyAsync(
      {
        RegisterServiceState currentState, RegisterCarServiceBloc bloc}) async {
    try {


      return new RegisteredServiceState();
    } catch (_, stackTrace) {

      return new ErrorRegisterServiceState(_?.toString());
    }
  }
}
