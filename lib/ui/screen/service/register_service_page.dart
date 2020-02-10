import 'package:anad_magicar/model/apis/api_service.dart';
import 'package:anad_magicar/model/viewmodel/service_vm.dart';
import 'package:anad_magicar/ui/screen/base/main_page.dart';
import 'package:anad_magicar/ui/screen/service/register_service_form.dart';
import 'package:anad_magicar/ui/screen/service/service_type/register_service_type_page.dart';

import 'package:flutter/material.dart';

class RegisterServicePage extends StatefulWidget {

  ServiceVM serviceVM;
  RegisterServicePage({Key key,this.serviceVM}) : super(key: key);

  @override
  RegisterServicePageState createState() {
    return RegisterServicePageState();
  }
}

class RegisterServicePageState extends MainPage<RegisterServicePage> {

  static final String route='/registerservicepage';


  addServiceType() async {
    Navigator.pushNamed(context,RegisterServicePageTypeState.route );
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  List<Widget> actionIcons() {
    // TODO: implement actionIcons
    return null;
  }

  @override
  String getCurrentRoute() {
    // TODO: implement getCurrentRoute
    return route;
  }

  @override
  FloatingActionButton getFab() {
    // TODO: implement getFab
    return FloatingActionButton(
      onPressed: (){ addServiceType(); },
      child: Icon(Icons.add,color: Colors.white,
        size: 30.0,),
      backgroundColor: Colors.blueAccent,
      elevation: 0.0,

    );
  }

  @override
  initialize() {
    // TODO: implement initialize
    return null;
  }

  @override
  Widget pageContent() {
    // TODO: implement pageContent
    return new RegisterServiceForm(
      editMode: widget.serviceVM.editMode,
      service: widget.serviceVM.service!=null ? widget.serviceVM.service : null,
      carId: widget.serviceVM.carId,);
  }

  @override
  int setCurrentTab() {
    // TODO: implement setCurrentTab
    return 0;
  }

}
