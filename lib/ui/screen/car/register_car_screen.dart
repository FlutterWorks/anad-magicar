import 'package:anad_magicar/bloc/car/register.dart';
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/components/RegisterButton.dart';
import 'package:anad_magicar/model/message.dart';
import 'package:anad_magicar/model/viewmodel/add_car_vm.dart';
import 'package:anad_magicar/model/viewmodel/init_data_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/car/register_car_form.dart';
import 'package:anad_magicar/ui/screen/device/register_device.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anad_magicar/components/RegisterForm.dart';
import 'package:flutter/material.dart';



class RegisterCarScreen extends StatefulWidget
{


  bool fromMainApp;
  AddCarVM addCarVM;
  @override
  _RegisterCarScreenState createState() {
    return _RegisterCarScreenState();
  }

  RegisterCarScreen({this.fromMainApp,this.addCarVM});

}

class _RegisterCarScreenState extends State<RegisterCarScreen>
{

  bool hasInternet=true;
  int _count=0;
  ValueChanged<String> onChanged;
  RegisterCarBloc registerCarBloc;
  NotyBloc<Message> _changeFormNotyBloc;
  bool _firstShow=true;

  Future<InitDataVM> initDataVM;
  InitDataVM _initDataVM;
  Future<InitDataVM> loadInitData() async {
    centerRepository.showProgressDialog(context, Translations.current.plzWaiting());
    if(widget.addCarVM!=null && widget.addCarVM.fromMainApp!=null && !widget.addCarVM.fromMainApp)
        initDataVM= centerRepository.loadInitData(true);
      else
        initDataVM=Future.value(new InitDataVM(
            carColor: null,
            carModel: null,
            carBrand: null,
            carDevice: null,
            carModels: null,
            carColors: null,
            carBrands: null,
            carDevices: null,
            carsToAdmin: null,
            relatedUsers: null));

    return initDataVM;
  }

  @override
  Widget build(BuildContext context) {
    return /*new WillPopScope(
      onWillPop: () async {
        return Navigator.pushReplacementNamed(context, "/home");
      },
      child:*/
      Scaffold(
        body: FutureBuilder<InitDataVM>(
          future: initDataVM,
          builder: (context,snapshot) {
            if (snapshot.hasData &&
                snapshot.data != null) {
              centerRepository.dismissDialog(context);
              _initDataVM = snapshot.data;
              return
                StreamBuilder<Message>(
                    stream: _changeFormNotyBloc.noty,
                    initialData: null,
                    builder: (BuildContext c, AsyncSnapshot<Message> data) {
                      if (data != null && data.hasData) {
                        Message message = data.data;
                        if (message.type == 'CAR_FORM') {
                          _firstShow = true;
                        }
                        if (message.type == 'DEVICE_FORM') {
                          _count = message.index;
                          if (message.text == 'INTERNET')
                            hasInternet = message.status;
                          _firstShow = false;
                         /* return RegisterDeviceScreen(
                            hasConnection: hasInternet,
                            fromMainApp: widget.fromMainApp,);*/
                        }
                      }
                      else {

                      }

                      return
                        new RegisterCarForm(
                          addCarVM: widget.addCarVM,
                          registerCarBloc: registerCarBloc,
                          changeFormNotyBloc: _changeFormNotyBloc,
                          carAddNotyBloc: widget.addCarVM.notyBloc,
                          fromMainApp: widget.addCarVM.fromMainApp,);
                    }
                );
          }
            return
              new Container(
                width: 0.0,
                height: 0.0);
          }
      ),

    );
  }
  @override
  void initState() {
    super.initState();
    registerCarBloc=new RegisterCarBloc();
    _changeFormNotyBloc=new NotyBloc<Message>();
    initDataVM=loadInitData();
  }

  @override
  void dispose() {
    registerCarBloc.close();
    _changeFormNotyBloc.dispose();
    super.dispose();
  }


}
