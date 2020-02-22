import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/components/no_data_widget.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/apis/api_service.dart';
import 'package:anad_magicar/model/apis/service_type.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/viewmodel/service_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/ui/screen/base/main_page.dart';
import 'package:anad_magicar/ui/screen/service/register_service_page.dart';
import 'package:anad_magicar/ui/screen/service/service_form.dart';
import 'package:anad_magicar/ui/screen/service/service_item.dart';
import 'package:anad_magicar/ui/screen/service/service_type/register_service_type_page.dart';
import 'package:anad_magicar/ui/screen/service/service_type/service_type_page.dart';
import 'package:anad_magicar/utils/date_utils.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:anad_magicar/widgets/flash_bar/flash_helper.dart';
import 'package:flutter/material.dart';

import '../../../translation_strings.dart';

class ServicePageNotDone extends StatefulWidget {
  int carId;
  ServiceVM serviceVM;
  ServicePageNotDone({Key key,this.carId,this.serviceVM}) : super(key: key);


  @override
  ServicePageNotDoneState createState() {
    return ServicePageNotDoneState();
  }
}

class ServicePageNotDoneState extends State<ServicePageNotDone> {

  static final String route='/servicepage';
  String serviceDate='';
  String alarmDate='';

  Future<List<ApiService>>  fServices;
  List<ApiService> servcies=new List();
  List<ServiceType> servcieTypes=new List();

  NotyBloc<ChangeEvent> notyDateBloc;
  void registerBus() {
    RxBus.register<ChangeEvent>().listen((ChangeEvent event)  {

      if(event.type=='SERVICE')
      {
        if(event.message=='DELETED'){
          fServices=loadCarServices(widget.serviceVM.carId);
        }
      }


    });
  }
  Future<List<ApiService>> loadCarServices(int carId) async {
    centerRepository.showProgressDialog(context, Translations.current.loadingdata());
    List<ApiService> result=await restDatasource.getCarService(widget.serviceVM.carId);
    if(result!=null && result.length>0)
      return result;
    return null;
  }
  addService()  {
    if(centerRepository.getServiceTypes()==null || centerRepository.getServiceTypes().length==0){
      FlashHelper.informationBar(context, message: Translations.current.noServiceTypes());
    }
    else {
      Navigator.pushNamed(context, RegisterServicePageState.route,
          arguments: new ServiceVM(carId: widget.serviceVM.carId,
              editMode: false,
              service: null));
    }
  }


  @override
  void initState() {
    fServices=loadCarServices(widget.serviceVM.carId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<List<ApiService>>(
        future: fServices,
        builder: (context,snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            centerRepository.dismissDialog(context);
            servcies = snapshot.data;
            List<ApiService> newServices= servcies.where((s)=>s.ServiceStatusConstId==Constants.SERVICE_NOTDONE).toList();
            return
              ServiceForm(carId: widget.serviceVM.carId, serviceVM: widget.serviceVM,servcies: newServices,);
          }
          else {
            if (widget.serviceVM != null && widget.serviceVM.refresh != null &&
                widget.serviceVM.refresh) {
              centerRepository.dismissDialog(context);
              fServices = loadCarServices(widget.serviceVM.carId);
            }
            return NoDataWidget();
          }
        }
    );
  }
}