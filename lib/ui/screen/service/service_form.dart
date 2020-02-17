import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/components/no_data_widget.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_service.dart';
import 'package:anad_magicar/model/apis/service_type.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:anad_magicar/model/viewmodel/service_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/service/register_service_page.dart';
import 'package:anad_magicar/ui/screen/service/service_item.dart';
import 'package:anad_magicar/utils/date_utils.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:anad_magicar/widgets/flash_bar/flash_helper.dart';
import 'package:flutter/material.dart';

class ServiceForm extends StatefulWidget {
  int carId;
  ServiceVM serviceVM;
  List<ApiService> servcies;
  ServiceForm({Key key,this.carId,this.serviceVM,this.servcies}) : super(key: key);

  @override
  _ServiceFormState createState() {
    return _ServiceFormState();
  }
}

class _ServiceFormState extends State<ServiceForm> {


  List<ServiceType> servcieTypes=new List();





  @override
  void initState() {
    servcieTypes=centerRepository.getServiceTypes();
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
            new Padding(padding: EdgeInsets.only(top: 60.0),
              child:
              Container(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: widget.servcies.length,
                    itemBuilder: (context, index) {
                      ApiService sTemp=widget.servcies[index];
                      var sT= servcieTypes.where((s)=>s.ServiceTypeId==widget.servcies[index].ServiceTypeId).toList();
                      ServiceType sType;
                      if(sT!=null && sT.length>0) {
                        sType = sT.first;
                        sTemp.serviceType=sType;
                      }
                      return ServiceItem(serviceItem: sTemp);
                    }),
              ),
            );


  }
}
