import 'package:anad_magicar/bloc/device/register.dart';
import 'package:anad_magicar/bloc/values/notify_value.dart';
import 'package:anad_magicar/components/fancy_popup/main.dart';
import 'package:anad_magicar/model/viewmodel/noty_loading_vm.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/device/add_device_form.dart';
import 'package:anad_magicar/widgets/flutter_offline/flutter_offline.dart';
import 'package:anad_magicar/widgets/forms_appbar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anad_magicar/bloc/register/register.dart';
import 'package:anad_magicar/components/RegisterForm.dart';
import 'package:flutter/material.dart';



class RegisterDeviceScreen extends StatefulWidget
{
  bool hasConnection;
  bool fromMainApp;
  @override
  _RegisterDeviceState createState() {
    return _RegisterDeviceState();
  }

  RegisterDeviceScreen({
    @required this.hasConnection,
    @required this.fromMainApp,

  });

}

class _RegisterDeviceState extends State<RegisterDeviceScreen>
{

  bool hasInternet=false;
  ValueChanged<String> onChanged;
  NotyBloc<NotyLoadingVM> _notyBloc;

  @override
  Widget build(BuildContext context) {

    return
      Scaffold(
        body: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
        /*OfflineBuilder(
          debounceDuration:  Duration.zero,
    connectivityBuilder: (
    BuildContext context,
    ConnectivityResult connectivity,
    Widget child,
    ) {
      hasInternet = connectivity != ConnectivityResult.none;
      if (connectivity == ConnectivityResult.none) {
          _notyBloc.updateValue(new NotyLoadingVM(isLoading: false,
              hasLoaded: false,
              haseError: false,
              hasInternet: false));
      }
        return child;
    },
    child:*/
        BlocProvider<RegisterDeviceBloc>(
          create: (context) => RegisterDeviceBloc(),
          child: new AddDeviceForm(hasConnection: true,fromMainApp: widget.fromMainApp,),
        ),
       // ),
              FormsAppBar( actionIcon: Icon(Icons.directions_car),loadingNoty: _notyBloc,
              onBackPress: widget.fromMainApp!=null && widget.fromMainApp ? Navigator.of(context).pop(false) : showPopUp() ,)
    ],
        ),
        );

  }


  @override
  void initState() {
    super.initState();
    _notyBloc=new NotyBloc<NotyLoadingVM>();
    hasInternet=widget.hasConnection;
  }

  @override
  void dispose() {
    super.dispose();
  }

  showPopUp()
  {
    final popup = BeautifulPopup(
      context: context,
      template: TemplateNotification,
    );
    popup.show(
      title: Translations.current.exit(),
      content: Translations.current.areYouSureToExit(),
      actions: [
        new Column(
          children: <Widget>[
            Container(
              height: 100.0,
              child:
              new Center(
                child: new Text(Translations.current.areYouSureToExit()),
              ),
            ),
            popup.button(
              label: Translations.current.exit(),
              onPressed: (){ SystemNavigator.pop();},
            ),
          ],
        )
      ],
// bool barrierDismissible = false,
// Widget close,
    );
  }


}
