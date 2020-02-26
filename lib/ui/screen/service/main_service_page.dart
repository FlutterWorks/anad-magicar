import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_service.dart';
import 'package:anad_magicar/model/apis/service_type.dart';
import 'package:anad_magicar/model/viewmodel/reg_service_type_vm.dart';
import 'package:anad_magicar/model/viewmodel/service_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/base/main_page.dart';
import 'package:anad_magicar/ui/screen/service/register_service_page.dart';
import 'package:anad_magicar/ui/screen/service/service_page.dart';
import 'package:anad_magicar/ui/screen/service/service_page_not_done.dart';
import 'package:anad_magicar/ui/screen/service/service_type/service_type_page.dart';
import 'package:anad_magicar/widgets/flash_bar/flash_helper.dart';

import 'package:flutter/material.dart';
import 'package:anad_magicar/widgets/persistence_tabbar.dart';
class MainPageService extends StatefulWidget {

  ServiceVM serviceVM;

  MainPageService({Key key,this.serviceVM}) : super(key: key);

  @override
  MainPageServiceState createState() {
    return MainPageServiceState();
  }
}

class MainPageServiceState extends MainPage<MainPageService> {

  static final String route='/servicepage';

  Future<List<ApiService>> loadCarServices(int carId) async {
    centerRepository.showProgressDialog(context, Translations.current.loadingdata());
    List<ApiService> result=await restDatasource.getCarService(widget.serviceVM.carId);
    if(result!=null && result.length>0)
      return result;
    return null;
  }

  loadServiceTypes() async{
    List<ServiceType> sTypes=new List();
    sTypes=await restDatasource.getCarServiceTypes();
    if(sTypes!=null && sTypes.length>0)
      centerRepository.setServiceTypes(sTypes);
  }

  addService()  {
    loadServiceTypes();
    if(centerRepository.getServiceTypes()==null || centerRepository.getServiceTypes().length==0){
      FlashHelper.informationBar(context, message: Translations.current.noServiceTypes());
    }
    else {
      Navigator.pushNamed(context, RegisterServicePageState.route,
          arguments: new ServiceVM(carId: widget.serviceVM.carId,
              car: widget.serviceVM.car,
              editMode: false,
              service: null));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  List<Widget> actionIcons() {
    // TODO: implement actionIcons
    List<Widget> actions=[

      IconButton(
        icon: Icon(Icons.directions_car,color: Colors.indigoAccent,),
        onPressed: (){
         Navigator.of(context).pushNamed(ServiceTypePageState.route,arguments: new RegServiceTypeVM(carId: widget.serviceVM.carId,
             route: route) );
        },
      ),
      IconButton(
        icon: Icon(Icons.arrow_forward,color: Colors.indigoAccent,),
        onPressed: (){
          Navigator.pushNamed(context, '/home');
        },
      ),
    ];
    return actions;
  }

  @override
  String getCurrentRoute() {
    // TODO: implement getCurrentRoute
    return null;
  }

  @override
  FloatingActionButton getFab() {
    // TODO: implement getFab
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: (){
        addService();
      },
      elevation: 0.0,
    );
  }

  @override
  initialize() {
    // TODO: implement initialize
    loadServiceTypes();
    return null;
  }

  @override
  Widget pageContent() {
    // TODO: implement pageContent
    return new MainPersistentTabBar(
      actions: <Widget> [
        IconButton(
          icon: Icon(Icons.directions_car,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pushNamed(ServiceTypePageState.route,arguments: widget.serviceVM.carId);
          },
        ),
      ],
      page1: ServicePage(serviceVM: widget.serviceVM,),
      page2: ServicePageNotDone(serviceVM: widget.serviceVM,),
    );
  }

  @override
  int setCurrentTab() {
    // TODO: implement setCurrentTab
    return 0;
  }
}
