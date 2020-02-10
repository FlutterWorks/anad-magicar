import 'package:anad_magicar/bloc/service/register.dart';
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/model/apis/api_service.dart';
import 'package:anad_magicar/model/user/user.dart';
import 'package:anad_magicar/model/viewmodel/noty_loading_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/ui/screen/service/fancy_register_service_form.dart';
import 'package:anad_magicar/ui/screen/service/fancy_service/src/models/car_service_data.dart';
import 'package:anad_magicar/ui/screen/service/service_page.dart';
import 'package:anad_magicar/widgets/forms_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterServiceForm extends StatefulWidget {

  int carId;
  bool editMode;
  ApiService service;
  RegisterServiceForm({Key key,this.carId,this.editMode,this.service}) : super(key: key);

  @override
  RegisterServiceFormState createState() {
    return RegisterServiceFormState();
  }
}

class RegisterServiceFormState extends State<RegisterServiceForm> {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  RegisterCarServiceBloc registerCarServiceBloc;
  User user;
  int userId;

  NotyBloc<NotyLoadingVM> loadingNoty;

  Future<String> _authAddCarService(CarServiceData data)
  {
    return Future.delayed(new Duration(microseconds: 200)).then((_) {
      if(data!=null &&
          !data.cancel) {
        ApiService service=new ApiService(
            ServiceId: data.serviceId,
            CarId: widget.carId,
            ServiceTypeId: data.serviceTypeId,
            ServiceDate: data.serviceDate,
            ActionDate: data.actionDate,
            AlarmDate: data.alarmDate,
            ServiceStatusConstId: ApiService.ServiceStatusConstId_Tag,
            ServiceCost: data.cost,
            AlarmCount: data.alarmCount,
            Description: data.description,
            CreatedDate: null,
            RowStateType: (widget.editMode!=null && widget.editMode) ?  Constants.ROWSTATE_TYPE_UPDATE :
            Constants.ROWSTATE_TYPE_INSERT);

          loadingNoty.updateValue(new NotyLoadingVM(isLoading: true,
              hasLoaded: false,
              haseError: false,
              hasInternet: true));
        /*BlocProvider.of<RegisterCarServiceBloc>(context).add(
              new LoadRegisterServiceEvent(user, service, context));*/
        registerCarServiceBloc.add(new LoadRegisterServiceEvent(user, service, context));

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
    loadUserId();
    registerCarServiceBloc=new RegisterCarServiceBloc();
    loadingNoty=new NotyBloc<NotyLoadingVM>();
  }

  @override
  void dispose() {
    registerCarServiceBloc.close();
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

          BlocBuilder<RegisterCarServiceBloc, RegisterServiceState>(
              bloc:  registerCarServiceBloc,
              builder: (
                  BuildContext context,
                  RegisterServiceState currentState,) {

                if(currentState is InRegisterServiceState)
                {
                  centerRepository.showProgressDialog(context, '');
                }
                if(currentState is RegisteredServiceState)
                {
                  centerRepository.dismissDialog(context);
                  loadingNoty.updateValue(new NotyLoadingVM(isLoading: false,
                      hasLoaded: false,
                      haseError: false,
                      hasInternet: true));
                  Navigator.pushReplacementNamed(context, ServicePageState.route);

                }
                if(currentState is ErrorRegisterServiceState)
                {

                  centerRepository.dismissDialog(context);
                  loadingNoty.updateValue(new NotyLoadingVM(isLoading: false,
                      hasLoaded: false,
                      haseError: true,
                      hasInternet: true));
                  centerRepository.showFancyToast(currentState.errorMessage);
                }
                return  new FancyRegisterServiceForm(
                  editMode: widget.editMode ,
                  service: widget.service,
                  onSubmit: _authAddCarService,
                authUser: _authAddCarService,
                recoverPassword: null,);
              }

          ),
          // ),
          //),
        ),
        /*FormsAppBar(
          onIconFunc: () {

          },
          actionIcon: null,
          loadingNoty: loadingNoty,
          onBackPress:() {} ,)*/
      ],
    );
  }
}
