import 'package:anad_magicar/data/ds/car_ds.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_user_model.dart';
import 'package:anad_magicar/model/apis/save_user_result.dart';
import 'package:anad_magicar/model/apis/service_result.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/repository/user/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/bloc/register/register.dart';
import 'package:anad_magicar/repository/center_repository.dart';

import 'package:meta/meta.dart';


@immutable
abstract class RegisterEvent {
  Future<RegisterState> applyAsync(
      {RegisterState currentState, RegisterBloc bloc});

}

class InRegisterEvent extends RegisterEvent{

  String token;
  String typeId;

  InRegisterEvent(this.token, this.typeId);

  @override
  Future<RegisterState> applyAsync({RegisterState currentState, RegisterBloc bloc}) async{
    if(currentState is UnRegisterState) {
      try {

            return new LoadRegisterState();

      }

      catch (_, stackTrace) {
        return new ErrorRegisterState(_?.toString());
      }
    }
    return new InRegisterState();
  }

}

class LoadRegisterEvent extends RegisterEvent {

  SaveUserModel user;
  CarDS carDS;
  BuildContext context;
  bool isEdit;
  LoadRegisterEvent(this.user,this.context,this.isEdit);

  @override
  String toString() => 'LoadRegisterEvent';

  @override
  Future<RegisterState> applyAsync({RegisterState currentState, RegisterBloc bloc}) async {

   try {

     if((isEdit!=null && !isEdit) || isEdit==null) {
       UserRepository userRepository = new UserRepository();
       SaveMagicarResponeQuery result = await userRepository.register(
           user: user);
       if (result != null &&
           result.isSuccessful) {
         if (result.carId != null &&
             result.carId > 0) {
           centerRepository.setCarIds(result.carId);

         }

         if (result.userId != null &&
             result.userId > 0) {
           centerRepository.setUserIds(result.userId);
           prefRepository.setLoginedUserId(result.userId);
           prefRepository.setLoginedUserName(user.UserName);
           prefRepository.setLoginedFirstName(user.FirstName);
           prefRepository.setLoginedLastName(user.LastName);
           prefRepository.setLoginedMobile(user.MobileNo);
           prefRepository.setLoginedPassword(user.Password);
           prefRepository.setUserRoleId(result.roleId);
         }
         // return new InRegisterSMSAuthState();
         return new RegisteredState();
       }
       return new ErrorRegisterState(result.message);
     }
     else
       {
         if(isEdit!=null && isEdit)
           {
           ServiceResult result= await restDatasource.editUserProfile(user);
           if(result!=null)
             {
               if(result.IsSuccessful)
                 {
                   return new RegisteredState();
                 }
               else
                 {
                   return new ErrorRegisterState(result.Message);
                 }
             }
           else
             {
               return new ErrorRegisterState(result.Message);
             }
           }
       }
    } catch (_, stackTrace) {
      return new ErrorRegisterState(_?.toString());
    }
  }
}

class RegisteredEvent extends RegisterEvent {
  User user;

  RegisteredEvent({this.user});
  @override
  String toString() => 'RegisteredEvent';

  @override
  Future<RegisterState> applyAsync(
      {
        RegisterState currentState, RegisterBloc bloc}) async {
    try {


      return new RegisteredState();
    } catch (_, stackTrace) {

      return new ErrorRegisterState(_?.toString());
    }
  }
}
