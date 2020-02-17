import 'package:anad_magicar/bloc/theme/change_theme_bloc.dart';
import 'package:anad_magicar/bloc/theme/theme.dart';
import 'package:anad_magicar/components/fancy_popup/main.dart';
import 'package:anad_magicar/model/viewmodel/car_page_vm.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/home/index.dart';
import 'package:anad_magicar/ui/screen/login/reset/fancy_login/src/models/login_data.dart';
import 'package:anad_magicar/ui/screen/login/reset/reset_password_form.dart';
import 'package:anad_magicar/ui/theme/app_themes.dart';
import 'package:anad_magicar/widgets/curved_navigation_bar.dart';
import 'package:anad_magicar/widgets/drawer/app_drawer.dart';
import 'package:anad_magicar/widgets/drawer/drawer.dart';
import 'package:anad_magicar/widgets/native_settings/src/settings_section.dart';
import 'package:anad_magicar/widgets/native_settings/src/settings_tile.dart';
import 'package:anad_magicar/widgets/native_settings/src/settings_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'languages_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String userName='';
  String imageUrl='';
  static final route='/appsettings';
  List<String> themeOptions = <String>[Translations.current.darkTheme(), Translations.current.lightTheme()];
  String selectedThemeOption = Translations.current.lightTheme();
  var itemAppTheme = AppTheme.values[4];

  bool lockInBackground = true;
  bool lightAppTheme=true;
  bool loginRequiered=false;
  bool useFinger=false;
  bool usePattern=false;
  bool usePassword=true;
  LoginType loginType;
  int themeOption;
  String mobile;
  bool isDark=false;
  int userId;
  Future<bool> getAppTheme() async{
    int dark=await changeThemeBloc.getOption();
    setState(() {
      if(dark==1)
        isDark=true;
      else
        isDark=false;
    });

  }

  Future<String>  _onSignUp(LoginData data)
    {
      return Future.delayed(new Duration(microseconds: 100)).then((_) {
        if (data.password!=null &&
        data.currentPassword!=null &&
        data.confrimPassword!=null &&
            data.password.isNotEmpty &&
            data.currentPassword.isNotEmpty &&
            data.confrimPassword.isNotEmpty) {


        }
        return '';
              });
    }

   Future<String> _onReset(LoginData data){
     return Future.delayed(new Duration(microseconds: 100)).then((_) {
     if (data.password!=null &&
         data.currentPassword!=null &&
         data.confrimPassword!=null &&
         data.password.isNotEmpty &&
         data.currentPassword.isNotEmpty &&
         data.confrimPassword.isNotEmpty) {


     }
     return '';
   });
    }
  showPopUp(String message)
  {
    final popup = BeautifulPopup(
      context: context,
      template: TemplateAuthentication,
    );
    popup.show(
      title: Translations.current.resetPassword(),
      content: message,
      actions: [
        new Column(
          children: <Widget>[
        Container(
          height: 100.0,
      child:
        ResetPasswordForm(
          onCancel: _onSignUp,
          authUser: _onReset,
          onSubmit: () {},
          recoverPassword: null,
        ),
        ),
        popup.button(
          label: Translations.current.exit(),
          onPressed: Navigator.of(context).pop,
        ),
          ],
        )
      ],
// bool barrierDismissible = false,
// Widget close,
    );
  }
  void _toggle() {
      selectedThemeOption=themeOptions[lightAppTheme ? 1 : 0];
      itemAppTheme=AppTheme.values[lightAppTheme ? 4 : 5];
  }

  setAppLogin()
  {
    prefRepository.setLoginStatus(loginRequiered);
    prefRepository.setLoginTypeStatus(loginType);
  }

  getUserMobile() async {
    //showPopUp(Translations.current.resetPassword());
    userId=await prefRepository.getLoginedUserId();
    mobile=await prefRepository.getLoginedMobile();
    if(mobile!=null)
      {
        setState(() {

        });
      }
  }

  onCarPageTap()
  {
    Navigator.of(context).pushNamed('/carpage',arguments: new CarPageVM(
        userId: userId,
        isSelf: true,
        carAddNoty: valueNotyModelBloc));
  }

  getThemeoption() async {
    changeThemeBloc.getOption().then((value){
        setState(() {
          themeOption=value;
          if(themeOption==0)
            lightAppTheme=true;
          else
            lightAppTheme=false;
        });
    });
  }
  @override
  void initState() {
    super.initState();
    getAppTheme();
    getThemeoption();
    getUserMobile();
    userName=centerRepository.getUserCached()!=null ?  centerRepository.getUserCached().userName : '';
    imageUrl=centerRepository.getUserCached()!=null ? centerRepository.getUserCached().imageUrl : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        drawer: AppDrawer(userName: userName,imageUrl: imageUrl,currentRoute: route,carPageTap: onCarPageTap,carId: CenterRepository.getCurrentCarId(),) ,//buildDrawer(context, route,userName,imageUrl,null,''),
    bottomNavigationBar: CurvedNavigationBar(
    index: 2,
    height: 60.0,
      color:  centerRepository.getBackNavThemeColor(!isDark),
      backgroundColor: centerRepository.getBackNavThemeColor(isDark),
    items: <Widget>[
    Icon(Icons.build, size: 30,color: Color(0xff455a64)),
    Icon(Icons.pin_drop, size: 30,color: Color(0xff455a64)),
    Icon(Icons.directions_car , size: 30,color:  Color(0xff455a64)),
    Icon(Icons.message, size: 30,color: Color(0xff455a64)),
    Icon(Icons.payment, size: 30,color: Color(0xff455a64),),
    ],
    onTap: (index) {
    //Handle button tap
    CenterRepository.onNavButtonTap(context, index,carId: CenterRepository.getCurrentCarId());
    },
    ),
    /*appBar: (widget.fromMain==null || !widget.fromMain) ?
      AppBar(title: Text(Translations.current.appSettings())) :
         null ,*/
    body:
    Stack(
        alignment: Alignment.topCenter,
        overflow: Overflow.visible,
        children: <Widget>[
    Align(
    alignment: Alignment(1,-1),
      child:
      Container(
        height:60.0,
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
      new Padding(padding: EdgeInsets.only(top: 80.0),
      child:
      SettingsList(
        sections: [
          SettingsSection(
            title: 'عمومی',
            tiles: [
              SettingsTile(
                title: 'زبان',
                subtitle: 'فارسی',
                leading: Icon(Icons.language),
                onTap: () {
                 /* Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => LanguagesScreen()));*/
                },
              ),
              SettingsTile.switchTile(
                  leftPadding: 25.0,
                  rightPadding: 2.0,
                  title: Translations.current.appTheme(),
                  subtitle: lightAppTheme ? Translations.current.lightTheme() :
                  Translations.current.darkTheme(),
                  switchValue: lightAppTheme,
                  onTap: () {
                    setState(() {
                      lightAppTheme=!lightAppTheme;
                      _toggle();
                     // BlocProvider.of<ThemeBloc>(context).add(new ThemeChanged(theme: itemAppTheme));
                      changeThemeBloc.onLightThemeChange();
                    });
                  },
                  onToggle: (bool value) {
                    setState(() {
                      lightAppTheme=value;
                      _toggle();
                      //BlocProvider.of<ThemeBloc>(context).add(new ThemeChanged(theme: itemAppTheme));
                      if(lightAppTheme)
                        changeThemeBloc.onLightThemeChange();
                      else
                        changeThemeBloc.onDarkThemeChange();
                    });

                  },
                  leading: Icon(Icons.ac_unit)),
            ],
          ),
          SettingsSection(
            title: 'کاربری',
            tiles: [
              SettingsTile(title: 'شماره همراه',
                  subtitle: mobile==null ? '' : mobile ,
                  leading: Icon(Icons.phone)),
              //SettingsTile(title: 'ایمیل', leading: Icon(Icons.email)),
              /*SettingsTile(title: 'خروج از حساب کاربری',
                  leading: Icon(Icons.exit_to_app),
              onTap: () {
                Navigator.of(context).pushNamed('/logout');
              },),*/
            ],
          ),
          /*SettingsSection(
            title: 'امنیتی',
            tiles: [
              SettingsTile.switchTile(
                title: Translations.current.useLogin(),
                leading: Icon(Icons.phonelink_lock),
                switchValue: loginRequiered,
                onToggle: (bool value) {
                  setState(() {
                    loginRequiered = value;
                    if(value) {
                      usePattern = !value;
                      usePassword = value;
                      useFinger = !value;
                    }
                    else
                      {
                        usePattern = value;
                        usePassword = value;
                        useFinger = value;
                      }
                    if(value)
                      setAppLogin();

                  });
                },
              ),
              SettingsTile.switchTile(
                  title: Translations.current.useFingerPrint(),
                  leading: Icon(Icons.fingerprint),
                  onToggle: (bool value) {
                    setState(() {
                      useFinger=value;
                      usePattern=!value;
                      usePassword=!value;
                      loginType=LoginType.FINGERPRINT;
                      setAppLogin();
                    });
                  },
                  switchValue: useFinger),
              SettingsTile.switchTile(
                  title: Translations.current.usePattern(),
                  leading: Icon(Icons.apps),
                  onToggle: (bool value) {
                    setState(() {
                        usePattern=value;
                        usePassword=!value;
                        useFinger=!value;
                        loginType=LoginType.PATTERN;
                        setAppLogin();

                    });
                  },
                  switchValue: usePattern),
              SettingsTile.switchTile(
                  title: Translations.current.usePassword(),
                  leading: Icon(Icons.apps),
                  onToggle: (bool value) {
                    setState(() {
                      usePattern=!value;
                      usePassword=value;
                      useFinger=!value;
                      loginType=LoginType.PASWWORD;
                      setAppLogin();

                    });
                  },
                  switchValue: usePassword),
              SettingsTile (
                title: 'تغییر رمز عبور',
                leading: Icon(Icons.lock),
                onTap: () {
                  _showResetPassword();
                },
              ),
            ],
          ),*/
          SettingsSection(
            title: 'درباره شرکت',
            tiles: [
              SettingsTile(
                  title: 'توضیحات', leading: Icon(Icons.description)),
              SettingsTile(
                  title: 'با مسئولیت محدود',
                  leading: Icon(Icons.collections_bookmark)),
            ],
          )
        ],
      ),
      ),
    ],
    ),
    );
  }
}
