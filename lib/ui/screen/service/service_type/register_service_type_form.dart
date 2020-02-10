import 'package:anad_magicar/bloc/service_type/register.dart';
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/model/apis/service_type.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/model/viewmodel/noty_loading_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';



import 'package:anad_magicar/ui/screen/service/service_type/fancy_register_service_type_form.dart';
import 'package:anad_magicar/ui/screen/service/service_type/fancy_service/flutter_car_service.dart';
import 'package:anad_magicar/widgets/forms_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterServiceTypeForm extends StatefulWidget {

  int carId;
  RegisterServiceTypeForm({Key key,this.carId}) : super(key: key);

  @override
  RegisterServiceTypeFormState createState() {
    return RegisterServiceTypeFormState();
  }
}

class RegisterServiceTypeFormState extends State<RegisterServiceTypeForm> {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  RegisterServiceTypeBloc registerServiceTypeBloc;
  User user;
  int userId;

  NotyBloc<NotyLoadingVM> loadingNoty;

  Future<String> _authAddCarServiceType(CarServiceTypeData data)
  {
    return Future.delayed(new Duration(microseconds: 200)).then((_) {
      if(data!=null &&
          !data.cancel) {
        ServiceType service=new ServiceType(
            ServiceTypeId: 0,
           AlarmCount:int.tryParse( data.alarmCount),
            AlarmDurationDay: data.alarmDurationDay,
            AutomaticInsert: data.automationInsert,
            DurationCountValue: data.durationCountValue,
            DurationTypeConstId: 0,
            DurationValue: data.durationValue,
            ServiceTypeCode: data.serviceTypeCode,
            ServiceTypeConstId: ServiceType.ServiceTypeConstId_Tag,
            ServiceTypeTitle: data.serviceTypeTitle,
            UserId: userId,
            Description: data.description,
            RowStateType: Constants.ROWSTATE_TYPE_INSERT);

          loadingNoty.updateValue(new NotyLoadingVM(isLoading: true,
              hasLoaded: false,
              haseError: false,
              hasInternet: true));
        BlocProvider.of<RegisterServiceTypeBloc>(context).add(
              new LoadRegisterServiceTypeEvent(user, service, context));

      }
      else if(data.cancel) {
          Navigator.pop(context);
      }
      else {
        return 'لطفا اطلاعات را بطور کامل وارد نمایید!';
      }
      return null;
    });
  }

  loadUserId() async {
    userId=await prefRepository.getLoginedUserId();
  }

  @override
  void initState() {
    super.initState();
    registerServiceTypeBloc=new RegisterServiceTypeBloc();
    loadingNoty=new NotyBloc<NotyLoadingVM>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Stack(
      overflow: Overflow.visible,
      children: <Widget> [
        new Padding(padding: EdgeInsets.only(top: 70.0),
          child:

          BlocBuilder<RegisterServiceTypeBloc, RegisterServiceTypeState>(
              bloc: RegisterServiceTypeBloc(),
              builder: (
                  BuildContext context,
                  RegisterServiceTypeState currentState,) {

                if(currentState is InRegisterServiceTypeState)
                {
                  centerRepository.showProgressDialog(context, '');
                }
                if(currentState is RegisteredServiceTypeState)
                {
                  centerRepository.dismissDialog(context);
                  loadingNoty.updateValue(new NotyLoadingVM(isLoading: false,
                      hasLoaded: false,
                      haseError: false,
                      hasInternet: true));


                }
                if(currentState is ErrorRegisterServiceTypeState)
                {

                  centerRepository.dismissDialog(context);
                  loadingNoty.updateValue(new NotyLoadingVM(isLoading: false,
                      hasLoaded: false,
                      haseError: true,
                      hasInternet: true));
                  centerRepository.showFancyToast(currentState.errorMessage);
                }
                return  new FancyRegisterServiceTypeForm(onSubmit: _authAddCarServiceType,
                authUser: _authAddCarServiceType,
                recoverPassword: null,);
              }

          ),
        ),
       /* FormsAppBar(
          onIconFunc: () {

          },
          actionIcon: null,
          loadingNoty: loadingNoty,
          onBackPress:() {} ,)*/
      ],
    );
  }
}
