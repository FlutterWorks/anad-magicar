import 'dart:async';

import 'package:anad_magicar/bloc/theme/change_theme_bloc.dart';
import 'package:anad_magicar/common/constants.dart';
import 'package:anad_magicar/components/button.dart';
import 'package:anad_magicar/components/flutter_form_builder/flutter_form_builder.dart';
import 'package:anad_magicar/components/no_data_widget.dart';
import 'package:anad_magicar/components/send_data.dart';
import 'package:anad_magicar/data/database_helper.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/api_car_model.dart';
import 'package:anad_magicar/model/apis/api_route.dart';
import 'package:anad_magicar/model/apis/api_search_car_model.dart';
import 'package:anad_magicar/model/apis/paired_car.dart';
import 'package:anad_magicar/model/apis/slave_paired_car.dart';
import 'package:anad_magicar/model/cars/car.dart';
import 'package:anad_magicar/model/join_car_model.dart';
import 'package:anad_magicar/model/user/admin_car.dart';
import 'package:anad_magicar/model/viewmodel/car_info_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_page_vm.dart';
import 'package:anad_magicar/model/viewmodel/car_state.dart';
import 'package:anad_magicar/model/viewmodel/map_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/map/geojson/geojson.dart';
import 'package:anad_magicar/ui/map/openmapstreet/pages/paired_car_expandable_panel.dart';
import 'package:anad_magicar/ui/screen/home/index.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:anad_magicar/utils/date_utils.dart';
import 'package:anad_magicar/widgets/bottom_sheet_custom.dart';
import 'package:anad_magicar/widgets/drawer/app_drawer.dart';
import 'package:anad_magicar/widgets/drawer/drawer.dart' as drw;
import 'package:anad_magicar/widgets/extended_navbar/extended_navbar_scaffold.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:latlong/latlong.dart';
import 'package:livemap/livemap.dart';
import 'package:location/location.dart';
import 'package:pedantic/pedantic.dart';
import '../widget/drawer.dart';
import 'package:geopoint/geopoint.dart';
import 'package:geopoint_location/geopoint_location.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart' show rootBundle;
import 'package:user_location/user_location.dart';
import 'package:flutter/material.dart';
import "package:collection/collection.dart";
import 'package:flutter/services.dart';
final List<String> carImgList = [
  "assets/images/car_red.png",
  "assets/images/car_blue.png",
  "assets/images/car_black.png",
  "assets/images/car_white.png",
  "assets/images/car_yellow.png",
  "assets/images/car_gray.png",
];

class MapPage extends StatefulWidget {


  int carId;
  int carCounts;
  List<AdminCarModel> carsToUser;
  MapVM mapVM;
  MapPage({
    @required this.mapVM,
    @required this.carId,
    @required this.carCounts,
    @required this.carsToUser
  });


  @override
  MapPageState createState() {
    // TODO: implement createState
    return new MapPageState();
  }



}

class MapPageState extends State<MapPage> {
  static const String route = '/mappage';
  String userName='';
  int userId=0;
  final String imageUrl = 'assets/images/user_profile.png';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autoValidate=false;
  bool isDark=false;
  List<CarInfoVM> carInfos=new List();
  Future<List<CarInfoVM>> carInfoss;
  Future<List<ApiPairedCar>> carsPaired;


  List<AdminCarModel> carsToUserSelf;
  List<ApiPairedCar> carsPairedList;
  List<SlavedCar> carsSlavePairedList;

  int _carCounts=0;
  LocationData currentLocation ;
  var location = new Location();

  List<Marker> markers = [];
  StreamController<LatLng> markerlocationStream = StreamController();
  UserLocationOptions userLocationOptions;

  final polygons = <Polygon>[];
  List<Polyline> lines = new List();//<Polyline>[];
  Future<List<Polyline>> lines2 ;

  MapController mapController;
  LiveMapController liveMapController;

  String pelakForSearch='';
  String carIdForSearch='';
  String mobileForSearch='';
  LatLng firstPoint;
  LatLng currentCarLatLng;

  //MapViewController controller;

  /*void _onMapViewCreated(MapViewController controller) {
    this.controller = controller;
  }*/
  getAppTheme() async{
    int dark=await changeThemeBloc.getOption();
    setState(() {
      if(dark==1)
        isDark=true;
      else
        isDark=false;
    });

  }

  getUserId() async {
    userId=await prefRepository.getLoginedUserId();
  }

  _onPelakChanged( value)
  {
    pelakForSearch=value.toString();
  }

  _onMobileChanged( value)
  {
    mobileForSearch=value.toString();
  }
  _onCarIdChanged( value)
  {
    carIdForSearch=value.toString();
  }

  _deleteCarFromPaired(int masterId,int  secondCar,) async{
    // var result=await restDatasource.savePairedCar(car);
    List<int> carIds=[secondCar];
    var result=await restDatasource.deletePairedCars(masterId, carIds);
     if(result!=null){
       if(result.IsSuccessful){
         centerRepository.showFancyToast(result.Message);
        // setState(() {
           carsSlavePairedList.removeWhere((c)=>c.CarId==secondCar);
         //});
       }else{
         centerRepository.showFancyToast(result.Message);
       }
     }
  }

  _showCarPairedActions(SlavedCar car,BuildContext context){
    showModalBottomSheetCustom(context: context ,
        mHeight: 0.70,
        builder: (BuildContext context) {
          return new Container(
            height: 250.0,
            child:
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          child : Button(color: Colors.pinkAccent.value,wid:120.0,title: Translations.current.delete(),),
          onTap: (){
            Navigator.pop(context);
            _deleteCarFromPaired(car.masterId,car.CarId);
          },),




        GestureDetector(
          child :Button(color: Colors.pinkAccent.value,wid:120.0,title: Translations.current.navigateToCurrent(),),
          onTap: (){
            Navigator.pop(context);
            navigateToCarSelected(0,true, car.CarId);
          },),



      ],
    ),
          );
        });
  }
  _showBottomSheetForSearchedCar(BuildContext cntext, Car car )
  {
    showModalBottomSheetCustom(context: cntext ,
        builder: (BuildContext context) {
          return new Container(
            height: 450.0,
            child:
            new Card(
              margin: new EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 78.0, bottom: 5.0),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white,width: 0.5),
                  borderRadius: BorderRadius.circular(8.0)),
              elevation: 0.0,
              child:
              new Container(
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  color: Color(0xfffefefe),
                  borderRadius: new BorderRadius.all(
                      new Radius.circular(5.0)),
                ),
                child:
                      Container(
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 10.0,left: 10.0),
                                child:
                                Text(Translations.current.carId()),),
                                Padding(
                                  padding: EdgeInsets.only(right: 10.0,left: 10.0),
                                  child:
                                Text(car.carId.toString()),),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 10.0,left: 10.0),
                                  child:
                                Text(Translations.current.carpelak()),),
                                Padding(
                                  padding: EdgeInsets.only(right: 10.0,left: 10.0),
                                  child:
                                Text(car.pelaueNumber),),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 10.0,left: 10.0),
                                  child:
                                  new Container(
                                    alignment: Alignment.center,
                                    decoration: new BoxDecoration(
                                      color: Colors.pinkAccent,
                                      borderRadius: new BorderRadius.all(
                                          new Radius.circular(5.0)),
                                    ),
                                    child:
                                  FlatButton(
                                      onPressed: (){

                                        String toDate=DateTimeUtils.convertIntoDateTime(DateTimeUtils.getDateJalali());
                                        String toTime=DateTimeUtils.getTimeNow();

                                        ApiPairedCar pairedCar=new ApiPairedCar(
                                            PairedCarId: 0, MasterCarId: widget.mapVM.carId,
                                            SecondCarId: car.carId,
                                            FromDate: toDate, ToDate: null,
                                            FromTime: toTime, ToTime: null ,
                                            Description: null, IsActive: true,
                                            RowStateType: Constants.ROWSTATE_TYPE_INSERT,
                                            CarIds: null, master: null, slaves: null);

                                        addCarToPaired(pairedCar);
                                      },
                                     child: Text( Translations.current.addToPaired())),),),

                              ],
                            ),

                          ],
                        ),
                      ),
              ),
            ),
          );
        });
  }
  searchCar() async{

    SearchCarModel searchCarModel=new SearchCarModel(
        AdminUserId: null,
        RequestFromThisUserId: null,
        CarId:int.tryParse( carIdForSearch),
        Message: null,
        userId: userId,
        pelak: pelakForSearch,
        DecviceSerialNumber: mobileForSearch);
    try {
     List<Car> result = await restDatasource.searchCars(int.tryParse( carIdForSearch),pelakForSearch,mobileForSearch);
     if(result!=null && result.length>0){
        _showBottomSheetForSearchedCar(context, result.first);
     }
    }
    catch(error)
    {
     print('');
    }

  }

  Future<List<CarInfoVM>> getCarInfo() async {

    carsToUserSelf= centerRepository.getCarsToAdmin();

    if(_carCounts==0) {

      if(centerRepository.getCarsToAdmin()!=null)
        _carCounts=centerRepository.getCarsToAdmin().length;
      fillCarInfo(carsToUserSelf);

    }
    var cars=await restDatasource.getAllPairedCars();
    carsPairedList=cars;
    carsSlavePairedList=new List();
    for(var c in cars) {
      for(var sc in c.slaves ){
        sc.masterId=c.master;
      }
      carsSlavePairedList..addAll(c.slaves);
    }
      return carInfos;
  }

  fillCarInfo(List<AdminCarModel> carsToUser)
  {
    carInfos = new List();
    int indx=0;
    for (var car in carsToUser) {
      Car car_info = centerRepository
          .getCars()
          .where((c) => c.carId == car.CarId)
          .toList()
          .first;
      if (car_info != null) {
        int tip=0;
        if(centerRepository.getCarBrands()!=null)
        {
          // tip=centerRepository.getCarBrands().where((d)=>d.brandId==car_info. )
        }
        SaveCarModel editModel=new SaveCarModel(
            carId: car_info.carId,
            brandId:0,
            modelId: null,
            tip: null,
            pelak: car_info.pelaueNumber,
            colorId: car_info.colorTypeConstId,
            distance: null,
            ConstantId: null,
            DisplayName: null,);

        CarStateVM carState=centerRepository.getCarStateVMByCarId(car_info.carId);

        CarInfoVM carInfoVM = new CarInfoVM(
            brandModel: null,
            car: car_info,
            carColor: null,
            carModel: null,
            carModelDetail: null,
            brandTitle: car_info.brandTitle,
            modelTitle: car_info.carModelTitle,
            modelDetailTitle: car_info.carModelDetailTitle,
            color: '',
            carId: car_info.carId,
            Description: car_info.description,
            fromDate: car.FromDate,
            CarToUserStatusConstId: car.CarToUserStatusConstId,
            isAdmin: car.IsAdmin,
            userId: car.UserId,
        imageUrl: carState!=null ? carState.carImage : carImgList[indx]);
        carInfos.add(carInfoVM);
        indx++;
      }

    }
  }

  Future<void> processData() async {
    final geojson = GeoJson();
    geojson.processedMultipolygons.listen((GeoJsonMultiPolygon multiPolygon) {
      for (final polygon in multiPolygon.polygons) {
        final geoSerie = GeoSerie(
            type: GeoSerieType.polygon,
            name: polygon.geoSeries[0].name,
            geoPoints: <GeoPoint>[]);
        for (final serie in polygon.geoSeries) {
          geoSerie.geoPoints.addAll(serie.geoPoints);
        }
        final color =
        Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
            .withOpacity(0.3);
        final poly = Polygon(
            points: geoSerie.toLatLng(ignoreErrors: true), color: color);
        setState(() => polygons.add(poly));
      }
    });
    geojson.endSignal.listen((bool _) => geojson.dispose());
    final data = await rootBundle.loadString('assets/images/test.geojson');
    final nameProperty = "ADMIN";
    unawaited(geojson.parse(data, nameProperty: nameProperty, verbose: true));
  }



  Future<List<Polyline>> processLineData(bool fromCurrent,
      String clat,String clng,
      String fromDate,String toDate,
      bool forReport) async {

    String sdate=DateTimeUtils.convertIntoDateTime(DateTimeUtils.getDateJalali());
    String tdate=DateTimeUtils.convertIntoDateTime(DateTimeUtils.getDateJalaliWithAddDays(-3));

    ApiRoute route=new ApiRoute(
        carId: widget.mapVM.carId,
        startDate: forReport ? DateTimeUtils.convertIntoDateTime(fromDate) : sdate,
        endDate: forReport ? DateTimeUtils.convertIntoDateTime(toDate) : tdate,
        dateTime: null,
        speed: null,
        lat: null,
        long: null,
        enterTime: null,
        carIds: null,
        DeviceId: null,
        Latitude: null,
        Longitude: null,
        Date: null,
        Time: null,
        CreatedDateTime: null);


    centerRepository.showProgressDialog(context, Translations.current.loadingdata());
    var queryBody = '{"coordinates":[';//$lng2,$lat2],[$lng1,$lat1]]}';
    if(!fromCurrent) {
      final pointDatas = await restDatasource.getRouteList(route);
      if (pointDatas != null && pointDatas.length > 0) {
        var points = '';
        int index = pointDatas.length - 1;
        firstPoint = LatLng(double.tryParse(pointDatas[0].lat),
            double.tryParse(pointDatas[0].lat));
        for (var i = 0; i < pointDatas.length; i++) {
          double lat = double.tryParse(pointDatas[i].lat);
          double lng = double.tryParse(pointDatas[i].long);

          if (i < index)
            points += '[$lng,$lat],';
          else
            points += '[$lng,$lat]';
          //points..add(item);
        }

        queryBody = queryBody + points + ']}';
      } else {
        var points = '';
        double lat = 35.7511447;
        double lng = 51.4716509 ;
        firstPoint = LatLng(lat,lng);
        double lat2 = 35.796249;
        double lng2 = 51.427583 ;

        points += '[$lng,$lat],';
        points += '[$lng2,$lat2]';
        queryBody = queryBody + points + ']}';

      }
    }
    else{
      if(currentLocation!=null) {
        double lat1 = double.tryParse(clat);
        double lng1 = double.tryParse(clng);

        if(clat==null || clat.isEmpty || clng==null || clng.isEmpty){
          lat1=  35.7511447;
          lng1=51.4716509;
        }

        double lat2 = double.tryParse(currentLocation.latitude.toString());
        double lng2 = double.tryParse(currentLocation.longitude.toString());

         queryBody = '{"coordinates":[[$lng2,$lat2],[$lng1,$lat1]]}';

      /*  var item1 = '[$lng2 , $lat2]';
        var item2 = '[$lng1 , $lat1]';*/
      }
      else
        {
          centerRepository.showFancyToast(Translations.current.yourLocationNotFound());
        }
    }
      final openRoutegeoJSON = await restDatasource
          .fetchOpenRouteServiceURlJSON(body: queryBody);
      if (openRoutegeoJSON != null) {
        final geojson = GeoJson();
        geojson.processedLines.listen((GeoJsonLine line) {
          final color = Color(
              (math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
              .withOpacity(0.5);
          lines.add(Polyline(
              strokeWidth: 12.0,
              color: color,
              points: line.geoSerie.toLatLng()));
        });
        geojson.endSignal.listen((_) {
          geojson.dispose();
        });
        // unawaited(geojson.parse(data, verbose: true));
        await geojson.parse(openRoutegeoJSON, verbose: true);
      }

    if(lines!=null && lines.length>0)
      return lines;
    else
    return null;
  }

  @override
  void initState() {
   // processData();

    super.initState();
    getUserId();
    location = new Location();
    mapController=new MapController();
   carInfoss= getCarInfo();
    getCurrentLoaction();

    liveMapController = LiveMapController(
      autoCenter: true, mapController: mapController, verbose: true,autoRotate: true,positionStreamEnabled: true,
      updateTimeInterval: 1,
      updateDistanceFilter: 1,);


     //currentLocation = LocationData;

    location.onLocationChanged().listen((LocationData currentLocation) {
      print(currentLocation.latitude);
      print(currentLocation.longitude);
      //mapController.move(LatLng(currentLocation.latitude,currentLocation.longitude), 17.0);
    });

    if(widget.mapVM!=null && widget.mapVM.forReport!=null &&
    widget.mapVM.forReport){
      lines2=processLineData(false, '', '',widget.mapVM.fromDate,widget.mapVM.toDate,widget.mapVM.forReport);
    }

  }


  Future<LocationData> getCurrentLoaction() async {
    try {
      currentLocation = await location.getLocation();
      if(currentLocation!=null) {
       // lines2= processLineData(currentLocation.latitude.toString(),currentLocation.longitude.toString());
        return currentLocation;
      }
    }  catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // error = 'Permission denied';
      }
      currentLocation = null;
    }
  }

  Future<ApiRoute> navigateToCarSelected(int index,bool isCarPaired,int carId) async{

    String imgUrl='';
    CarInfoVM carInfo;
    //SlavedCar carSlave;
    if(isCarPaired){
       // carSlave=carsSlavePairedList[index];
    }
    else{
      carInfo=carInfos[index];
    }

    List<int> carIds=new List();
    if(isCarPaired) {carIds..add(carId);
    imgUrl=carImgList[0];
    }
      else {
        carIds..add(carInfo.carId);
        imgUrl=carInfo.imageUrl;
    }

    ApiRoute apiRoute=new ApiRoute(carId: null,
        startDate: null,
        endDate: null,
        dateTime: null,
        speed: null,
        lat: null,
        long: null,
        enterTime: null,
        carIds: carIds,
        DeviceId: null,
        Latitude: null,
        Longitude: null,
        Date: null,
        Time: null,
        CreatedDateTime: null);
    var result=await restDatasource.getLastPositionRoute(apiRoute);
    if(result!=null && result.length>0)
      {

        double lat=double.tryParse( result[0].Latitude);
        double lng=double.tryParse(result[0].Longitude);
        LatLng latLng=LatLng(lat,lng);
        currentCarLatLng=LatLng(lat,lng);
        liveMapController.mapController.move(latLng, 14);
      var marker=  Marker(
          width: 40.0,
          height: 40.0,
          point: latLng,
          builder: (ctx) => Container(
            width: 38.0,
            height: 38.0,
            child: CircleAvatar(
              radius: 38.0,
                backgroundColor: Colors.transparent,
                child: Image.asset(imgUrl,key: ObjectKey(Colors.green),))
          ),
        );

        markers.add(marker);

      }else {
      double lat = 35.796249;
      double lng = 51.427583 ;
      LatLng latLng=LatLng(lat,lng);
      currentCarLatLng=LatLng(lat,lng);
      liveMapController.mapController.move(latLng, 14);
      var marker=  Marker(
        width: 40.0,
        height: 40.0,
        point: latLng,
        builder: (ctx) => Container(
            width: 38.0,
            height: 38.0,
            child: CircleAvatar(
                radius: 38.0,
                backgroundColor: Colors.transparent,
                child: Image.asset(imgUrl,key: ObjectKey(Colors.green),))
        ),
      );

      markers.add(marker);
    }
  }

  addCarToPaired(ApiPairedCar car) async {
    var result=await restDatasource.savePairedCar(car);
    if(result!=null) {
      centerRepository.showFancyToast(result.Message);
      if( result.IsSuccessful){
     setState(() {

     });
   }
   else {

   }
  }
  }

  onCarPageTap()
  {
    Navigator.of(context).pushNamed('/carpage',arguments: new CarPageVM(
        userId: centerRepository.getUserCached().id,
        isSelf: true,
        carAddNoty: valueNotyModelBloc));
  }

  List<Widget> getCarsTiles(List<ApiPairedCar> cars) {
    List<Widget> list = [];
   /* if (cars != null) {
      for (ApiPairedCar c in cars) {
        //Car car=centerRepository.getCars().where((cr)=>cr.carId==c.CarId).toList().first;
        String name = DartHelper.isNullOrEmptyString(c.);
        String desc=DartHelper.isNullOrEmptyString(c.Description);
        String carId=c.CarId.toString();
        String modelTitle=DartHelper.isNullOrEmptyString(c.CarModelTitle);
        String detailTitle=DartHelper.isNullOrEmptyString(c.CarModelDetailTitle);

        int statusId=c.CarToUserStatusConstId;
        list.add(
          Container(
            margin: EdgeInsets.only(bottom: 2.0),
            decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                border:Border.all(color: Colors.black38.withOpacity(0.1),width: 0.5)
            ),
            child:
            Column(
              children: <Widget>[
                ListTile(
                    title:Card(
                      color: Colors.black12.withOpacity(0.0),
                      margin: new EdgeInsets.only(
                          left: 2.0, right: 2.0, top: 5.0, bottom: 5.0),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white,width: 0.0),
                        borderRadius: new BorderRadius.all(Radius.circular(5.0)),
                      ),
                      // color: Color(0xfffefefe),
                      elevation: 0.0,
                      child:
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:  EdgeInsets.only(right: 0.0),
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 5.0,left: 5.0),
                                  child:
                                  Text( Translations.current.carId(),style: TextStyle(fontSize: 18.0)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 5.0,left: 5.0),
                                  child:
                                  Text( carId,style: TextStyle(fontSize: 20.0)),),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 5.0,left: 5.0),
                                child:
                                Text(Translations.current.carTitle(),style: TextStyle(fontSize: 18.0)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 5.0,left: 5.0),
                                child:
                                Text(name ,style: TextStyle(fontSize: 18.0)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 5.0,left: 5.0),
                                child:
                                Text(Translations.current.carModelTitle(),style: TextStyle(fontSize: 18.0)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 5.0,left: 5.0),
                                child:
                                Text(modelTitle ,style: TextStyle(fontSize: 18.0)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 5.0,left: 5.0),
                                child:
                                Text(Translations.current.carModelDetailTitle(),style: TextStyle(fontSize: 18.0)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 5.0,left: 5.0),
                                child:
                                Text(detailTitle ,style: TextStyle(fontSize: 18.0)),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                    subtitle: Text(  Translations.current.description()+' : '+ DartHelper.isNullOrEmptyString( desc)),
                    trailing: Container(width: 0.0,height: 0.0,)
                ),
                Container(
                  height: 48.0,
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                        padding: EdgeInsets.only(left: 0, right: 0),
                        child: Button(title: Translations.current.selectForJoin(),wid: 100.0,color: Colors.blueAccent.value,),
                        onPressed: () {
                          addCarToPaired(c);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }*/
    return list;
  }
  _showBottomSheetLastCars(BuildContext cntext,  List<ApiPairedCar> cars)
  {
    showModalBottomSheetCustom(context: cntext ,
        builder: (BuildContext context) {
          return new Container(
            height: 450.0,
            child:
            new Card(
              margin: new EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 78.0, bottom: 5.0),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white,width: 0.5),
                  borderRadius: BorderRadius.circular(8.0)),
              elevation: 0.0,
              child:
              new Container(
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  color: Color(0xfffefefe),
                  borderRadius: new BorderRadius.all(
                      new Radius.circular(5.0)),
                ),
                child:
                PairedCarsExpandPanel(cars: cars,),
              ),
            ),
          );
        });
  }
  showLastCarJoint(BuildContext cntext) async {
    //var cars=await databaseHelper.getLastCarsJoint();
    var cars=await restDatasource.getAllPairedCars();
    if(cars!=null && cars.length>0)
        _showBottomSheetLastCars(cntext, cars);
  }

  showRouteCurrentToCar(){
    if(currentCarLatLng!=null) {
      String clat=currentCarLatLng.latitude.toString();
      String clng=currentCarLatLng.longitude.toString();
      lines2 = processLineData(true,clat, clng,'','',false);
    }
    else{
      centerRepository.showFancyToast(Translations.current.plzSelectACarToRoute());
    }
  }

  showCarRoute(){
    lines2=processLineData(false, '', '','','',false);
  }

  @override
  void dispose() {
    markerlocationStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    markerlocationStream.stream.listen((onData) {
      print(onData.latitude);
    });
    userLocationOptions = UserLocationOptions(
        context: context,
        mapController: mapController,
        markers: markers,
        onLocationUpdate: (LatLng pos) {
          print("onLocationUpdate ${pos.toString()}");
         // mapController.move(pos, 17.0);
        },
        updateMapLocationOnPositionChange: false,
        showMoveToCurrentLocationFloatingActionButton: true,
        zoomToCurrentLocationOnLoad: true,
        fabBottom: 160,
        fabRight: 20,
        verbose: false);
    return FutureBuilder<List<CarInfoVM>>(
        future: carInfoss ,
        builder: (context,snapshot)
    {
      if (snapshot.hasData &&
          snapshot.data != null) {
        final parallaxCardItemsList = <ParallaxCardItem>[
          for(var car in carInfos)
            ParallaxCardItem(
                title: DartHelper.isNullOrEmptyString(car.car.pelaueNumber),
                body: DartHelper.isNullOrEmptyString(car.carId.toString()),
                background: Container(
                  width: 50.0,
                  color: Colors.white,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 30.0,
                    child: Image.asset(car.imageUrl),
                  ),
                )),


        ];

        final carPairedItemsList = <ParallaxCardItem>[
          for(var car in carsSlavePairedList)
            ParallaxCardItem(
                title: DartHelper.isNullOrEmptyString(car.BrandTitle),
                body: DartHelper.isNullOrEmptyString(car.CarId.toString()),
                background: Container(
                  width: 160.0,
                  color: Theme.of(context).cardColor,
                  child: Container(
                      child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            Row(
                              children: <Widget>[
                                Text(Translations.current.thisCarPaired(),style: TextStyle(fontSize: 10.0),),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(Translations.current.masterCarId(),style: TextStyle(fontSize: 10.0)),
                                Text(DartHelper.isNullOrEmptyString(car.masterId.toString()),style: TextStyle(fontSize: 10.0)),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(DartHelper.isNullOrEmptyString(car.CarModelTitle),style: TextStyle(fontSize: 10.0)),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(DartHelper.isNullOrEmptyString(car.CarModelDetailTitle),style: TextStyle(fontSize: 10.0)),
                              ],
                            ),

    ],
                    ),
    ),
                ),
            ),
        ];

      return
        ExtendedNavigationBarScaffold(
          key: _scaffoldKey,
          drawer: AppDrawer(userName: userName,currentRoute: route,imageUrl: imageUrl,carPageTap: onCarPageTap,carId: widget.mapVM.carId,),
          body:
          Stack(
              overflow: Overflow.visible,
              children: <Widget>[

          FutureBuilder<List<Polyline>>(
              future: lines2,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data != null) {
                  centerRepository.dismissDialog(context);
                  return
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text(
                                ''),
                          ),
                          Flexible(
                            child: Stack(
                              children: <Widget>[
                                FlutterMap(
                                  mapController: liveMapController
                                      .mapController,
                                  options: MapOptions(
                                    center: firstPoint!=null ? firstPoint : currentLocation!=null ?
                                   LatLng( currentLocation.latitude,currentLocation.longitude) : LatLng(35.6917856,51.4204603) ,
                                    zoom: 15.0,
                                    plugins: [
                                      UserLocationPlugin(),
                                    ],
                                  ),

                                  layers: [
                                    TileLayerOptions(
                                      urlTemplate:
                                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      subdomains: ['a', 'b', 'c'],
                                      // NetworkTileProvider or CachedNetworkTileProvider
                                      tileProvider: CachedNetworkTileProvider(),
                                    ),

                                    PolylineLayerOptions(polylines: lines),
                                    MarkerLayerOptions(markers: markers),
                                    userLocationOptions
                                    /* PolygonLayerOptions(
                    polygons: polygons,
                  ),*/
                                  ],
                                ),

                            Positioned(
                              right: 20.0,
                              bottom: 210.0,
                              child:
                              Container(
                                  width: 38.0,
                                  height: 38.0,
                                  child:
                                  FloatingActionButton(
                                    onPressed: (){
                                      showRouteCurrentToCar();
                                    },
                                    child:Container(
                                      width: 38.0,
                                      height: 38.0,
                                      child: Image.asset('assets/images/go.png',color: Colors.white,),),
                                    elevation: 3.0,
                                    backgroundColor: Colors.blueAccent,
                                  ),
                              ),
                                ),
                              ],
                            ),
                          ),
                        ],

                      ),
                    );
                }
                else {
                  double lat = currentLocation != null ? currentLocation
                      .latitude : 35.6917856;
                  double long = currentLocation != null ? currentLocation
                      .longitude : 51.4204603;
                  return Column(
                      children: [
                        Flexible(
                    child: Stack(
                        children: <Widget>[
                    FlutterMap(
                    options: MapOptions(
                      center: LatLng(lat, long),
                      zoom: 16.0,
                      plugins: [
                        UserLocationPlugin(),
                      ],
                    ),
                    layers: [
                      TileLayerOptions(
                        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                        tileProvider: CachedNetworkTileProvider(),
                      ),

                      PolylineLayerOptions(polylines: lines),
                      MarkerLayerOptions(markers: markers),
                      userLocationOptions
                    ],
                    mapController: liveMapController.mapController,
                ),
                Positioned(
                right: 20.0,
                bottom: 210.0,
                child:
                Container(
                  width: 38.0,
                height: 38.0,
                child:
                FloatingActionButton(
                onPressed: (){
                  showRouteCurrentToCar();
                },
                child:Container(
                width: 38.0,
                height: 38.0,
                child: Image.asset('assets/images/go.png',color: Colors.white,),),
                elevation: 3.0,
                backgroundColor: Colors.blueAccent,
                )
                ),
                ),
                ],
                    ),
                        ),
                ],

                  );
                }
              }
         // ),
          ),

          ],
          ),
          elevation: 0,
          floatingAppBar: true,
          floatAppbar:
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment(1,-1),
                            child:
                            Container(
                              height:70.0,
                              child:
                              AppBar(
                                automaticallyImplyLeading: true,
                                backgroundColor: Colors.transparent,
                                elevation: 0.0,
                                actions: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.arrow_forward,color: Colors.indigoAccent,),
                                    onPressed: (){
                                      Navigator.pushNamed(context, '/home');
                                    },
                                  ),
                                ],
                                leading: IconButton(
                                  icon: Icon(Icons.menu,color: Colors.indigoAccent,),
                                  onPressed: (){
                                    _scaffoldKey.currentState.openDrawer();
                                  },
                                ),
                              ),
                            ),
                          ),
          Padding(
            padding: EdgeInsets.only(top: 60.0),
            child:
          Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width-10,
            height: 110.0,
            child:
            PageTransformer(
              pageViewBuilder: (context, visibilityResolver) {
                return
                  PageView.builder(
                    physics: BouncingScrollPhysics(),
                    controller: PageController(viewportFraction: 0.5,),
                    itemCount: parallaxCardItemsList.length,
                    itemBuilder: (context, index) {
                      final item = parallaxCardItemsList[index];
                      final pageVisibility =
                      visibilityResolver.resolvePageVisibility(index);
                      return GestureDetector(
                        onTap: (){
                          navigateToCarSelected(index,false,0);
                        },
                        child:
                       Container(
                        color: Colors.white.withOpacity(0.0),
                          width: 200.0,
                          height: 100.0,
                          child: ParallaxCardsWidget(
                        item: item,
                        pageVisibility: pageVisibility,
                          ),
                       ),
                      );
                    },
                  );
              },
            ),
          ),
          ),
          ],),
          appBar: AppBar(
            shape: kAppbarShape,
            actions: <Widget>[

            ],
            leading: IconButton(
              icon: Icon(
                EvaIcons.person,
                color: Colors.pinkAccent,
              ),
              onPressed: () {},
            ),
            title: Text(
              'خودروهای تعریف شده',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          navBarColor: Colors.white,
          navBarIconColor: Colors.blueAccent,
          moreButtons: [
            MoreButtonModel(
              icon: MaterialCommunityIcons.account_question,
              label: 'درخواست ها',
              onTap: () {
                showLastCarJoint(context);
              },
            ),
            MoreButtonModel(
              icon: MaterialCommunityIcons.parking,
              label: 'مسیر طی شده',
              onTap: () { showCarRoute();},
            ),
            MoreButtonModel(
              icon: FontAwesome.book,
              label: 'مسیریابی',
              onTap: () { showRouteCurrentToCar();},
            ),
           null,
           /* MoreButtonModel(
              icon: MaterialCommunityIcons.car_multiple,
              label: 'خودرهای من',
              onTap: () {},
            ),*/

            null,
            /*MoreButtonModel(
              icon: MaterialCommunityIcons.home_map_marker,
              label: 'ارسال پیام',
              onTap: () {},
            ),*/
            null,
            /*MoreButtonModel(
              icon: FontAwesome5Regular.user_circle,
              label: 'گروه خودروها',
              onTap: () {},
            ),*/
            null,
            null,
            /*MoreButtonModel(
              icon: EvaIcons.settings,
              label: 'تنظیمات',
              onTap: () {},
            ),*/
            null,
          ],
          searchWidget: Container(
            width: 350.0,
            height: 300,
         child:
          Stack(
            children: <Widget>[
                new ListView (
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      //margin: EdgeInsets.symmetric(horizontal: 20.0),
                      children: <Widget>[
                        SizedBox(
                          height: 0,
                        ),
                       /* FlatButton(
                          onPressed: (){ showLastCarJoint(context);},
                          child: Button(color: Colors.blueAccent.value,wid: 220,title: Translations.current.carJoindBefore(),),
                        ),*/
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 12.0),
                          width:MediaQuery.of(context).size.width*0.70,
                          child:
                          Form(
                            key: _formKey,
                            autovalidate: _autoValidate,
                            child:
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              physics: BouncingScrollPhysics(),
                              child: new Column(
                                children: <Widget>[

                                  Container(
                                    //height: 45,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.0, horizontal: 2.0),
                                    child:
                                    FormBuilderTextField(
                                      initialValue: '',
                                      attribute: "CarId",
                                      decoration: InputDecoration(
                                        labelText: Translations.current.carId(),
                                      ),
                                      onChanged: (value) => _onCarIdChanged(value),
                                      valueTransformer: (text) => num.tryParse(text),
                                      validators: [
                                        FormBuilderValidators.required(),
                                        FormBuilderValidators.numeric(),
                                        FormBuilderValidators.max(20),
                                      ],
                                      keyboardType: TextInputType.number,
                                    ),

                                  ),
                                  Container(
                                    // height: 45,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.0, horizontal: 2.0),
                                    child:
                                    FormBuilderTextField(
                                      initialValue: '',
                                      attribute: "SerialNumber",
                                      decoration: InputDecoration(
                                        labelText: Translations.current.serialNumber(),
                                      ),
                                      onChanged: (value) => _onMobileChanged(value),
                                      valueTransformer: (text) => text,
                                      validators: [
                                       // FormBuilderValidators.required(),
                                        FormBuilderValidators.numeric(),
                                        FormBuilderValidators.max(70),
                                      ],
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  Container(
                                    // height: 45,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.0, horizontal: 2.0),
                                    child:
                                    FormBuilderTextField(
                                      initialValue: '',
                                      attribute: "Pelak",
                                      inputFormatters: [BlacklistingTextInputFormatter(RegExp("[,@#%^&*()+=!.`~\"';:?؟و/\\\\]"))],
                                      decoration: InputDecoration(
                                        labelText: Translations.current.carpelak(),
                                      ),
                                      onChanged: (value) => _onPelakChanged(value),
                                      valueTransformer: (text) => text,
                                      validators: [
                                        FormBuilderValidators.required(),
                                      ],
                                     // keyboardType: TextInputType.text,
                                    ),
                                  ),


                                  new GestureDetector(
                                    onTap: () {
                                      searchCar();
                                    },
                                    child:
                                    Container(

                                      child:
                                      new SendData(),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),


            ],
          ),
          ),
          // onTap: (button) {},
          // currentBottomBarCenterPercent: (currentBottomBarParallexPercent) {},
          // currentBottomBarMorePercent: (currentBottomBarMorePercent) {},
          // currentBottomBarSearchPercent: (currentBottomBarSearchPercent) {},
          parallexCardPageTransformer: PageTransformer(
            pageViewBuilder: (context, visibilityResolver) {
              return
                PageView.builder(
                  controller: PageController(viewportFraction: 0.50),
                  itemCount: carPairedItemsList.length,
                  itemBuilder: (context, index) {
                    final item = carPairedItemsList[index];
                    final pageVisibility =
                    visibilityResolver.resolvePageVisibility(index);
                    return GestureDetector(
                    child:
                      Container(
                        color: Colors.white.withOpacity(0.0),
                        width: 200.0,
                        height: 130.0,
                        child: ParallaxCardsWidget(
                          item: item,
                          pageVisibility: pageVisibility,
                        ),
                      ),
                      onTap: (){
                        _showCarPairedActions(carsSlavePairedList[index],context);
                      },
                    );
                  },
                );
            },
          ),
        );
    }
      else
        {
          return NoDataWidget();
        }
  },
    );
 // },
 // );




  }


  void addGeoMarkerFromCurrentPosition() async {
    GeoPoint gp = await geoPointFromLocation(name: "Current position");
    Marker m = Marker(
        width: 180.0,
        height: 250.0,
        point: gp.point,
        builder: (BuildContext context) {
          return Icon(Icons.location_on);
        });
    await liveMapController.addMarker(marker: m, name: "Current position");
    await liveMapController.fitMarker("Current position");
  }

  void addGeoMarkerFromPosition(LatLng pos) async {
    GeoPoint gp = await  geoPointFromLocation(name: "Current position");
    Marker m = Marker(
        width: 180.0,
        height: 250.0,
        point: gp.point,
        builder: (BuildContext context) {
          return Icon(Icons.location_on);
        });
    await liveMapController.addMarker(marker: m, name: "Current position");
    await liveMapController.fitMarker("Current position");
  }

}
