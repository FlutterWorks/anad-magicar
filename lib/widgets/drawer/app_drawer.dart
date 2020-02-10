import 'package:anad_magicar/components/CircleImage.dart';
import 'package:anad_magicar/data/rest_ds.dart';
import 'package:anad_magicar/model/apis/service_result.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/repository/pref_repository.dart';
import 'package:anad_magicar/repository/user/user_repo.dart';
import 'package:anad_magicar/translation_strings.dart';
import 'package:anad_magicar/ui/screen/car/car_page.dart';
import 'package:anad_magicar/ui/screen/profile/profile2.dart';
import 'package:anad_magicar/ui/screen/setting/native_settings_screen.dart';
import 'package:anad_magicar/ui/screen/setting/security_settings_form.dart';
import 'package:anad_magicar/ui/screen/user/user_page.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/widgets/animated_dialog_box.dart';

class AppDrawer extends StatelessWidget {

  String currentRoute;
  String userName;
  String imageUrl;
  Function carPageTap;
  AppDrawer({Key key,this.userName,this.imageUrl,this.currentRoute,this.carPageTap}) : super(key: key);


  _logout(BuildContext context) async {
    ServiceResult result = await restDatasource.logoutUser();
    if (result != null) {

      if(result.IsSuccessful) {
        centerRepository.showFancyToast(Translations.current.logoutSuccessful());
        UserRepository userRepo = new UserRepository();
        userRepo
            .deleteToken(); //(username: widget.user.mobile,password: widget.user.password,code: widget.user.code);
        await prefRepository.setLoginStatus(true);
        await prefRepository.setLoginTypeStatus(LoginType.PASWWORD);

        Navigator.pushReplacementNamed(context, '/login');
      }
      else{
        if(result.Message!=null)
          centerRepository.showFancyToast(result.Message);
        else
          centerRepository.showFancyToast(Translations.current.hasErrors());
      }
    }
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image:  AssetImage('assets/images/login_back.jpg'))),
        child: Stack(children: <Widget>[
          Positioned(
              top: 20.0,
              right: 10.0,
              child: new Container(
                width: 80.0,
                height: 80.0,
                decoration: new BoxDecoration(
                  // Circle shape
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    // The border you want
                    border: new Border.all(
                      width: 1.0,
                      color: Colors.white,
                    ),
                    // The shadow you want
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5.0,
                      ),
                    ]
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius:100.0,
                child:
                Image.asset(imageUrl,width: 60.0,height: 60.0,),),
              )
    ),
          Positioned(
              top: 100.0,
              right: 10.0,
              child: new Container(
                //width: 80.0,
                height: 50.0,
                /*decoration: new BoxDecoration(
                  // Circle shape
                   // shape: BoxShape.circle,
                    color: Colors.transparent,
                    // The border you want
                    border: new Border.all(
                      width: 0.0,
                      color: Colors.white,
                    ),
                    // The shadow you want
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 0.0,
                      ),
                    ]
                ),*/
                child: Text(userName,style: TextStyle(color: Colors.white,fontSize: 35.0),
                  ),
              )
          ),
        ]),
    );
  }
  Widget _createDrawerItem(
      {BuildContext context, IconData icon, String text, bool isSelected,GestureTapCallback onTap}) {
    return ListTile(
      selected: isSelected ,
      subtitle: null,
      title: Container(
        color: isSelected ? Colors.blueAccent.withOpacity(0.5) : Theme.of(context).appBarTheme.color,
        child:
      Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(context: context, icon: Icons.person_add,text: Translations.current.users(),isSelected: currentRoute==UserPageState.route, onTap: (){ Navigator.pushReplacementNamed(context, UserPageState.route);}),
          _createDrawerItem(context: context,icon: Icons.directions_car, text: Translations.current.car(),isSelected: currentRoute==CarPageState.route, onTap: (){carPageTap();}),
          _createDrawerItem(context: context,icon: Icons.security, text: Translations.current.security(),isSelected: currentRoute==SecuritySettingsFormState.route, onTap: (){ Navigator.pushReplacementNamed(context, SecuritySettingsFormState.route,arguments: true);}),
          Divider(),
          _createDrawerItem(context: context,icon: Icons.settings, text: Translations.current.settings(),isSelected: currentRoute==SettingsScreenState.route, onTap: (){Navigator.pushReplacementNamed(context, SettingsScreenState.route);}),
          _createDrawerItem(context: context,icon: Icons.person_pin, text: Translations.current.profile(),isSelected: currentRoute==ProfileTwoPageState.route, onTap: (){Navigator.pushReplacementNamed(context, ProfileTwoPageState.route,arguments: centerRepository.getUserInfo());}),
          _createDrawerItem(context: context,icon: Icons.report, text: Translations.current.report(),isSelected: currentRoute=='', onTap: (){}),
          _createDrawerItem(context: context,icon: Icons.exit_to_app,isSelected: false, text: Translations.current.exit(),onTap: () async{
            await animated_dialog_box.showScaleAlertBox(
                title:Center(child: Text(Translations.current.logoutAccount())) , // IF YOU WANT TO ADD
                context: context,
                firstButton: MaterialButton(
                  // FIRST BUTTON IS REQUIRED
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  color: Colors.white,
                  child: Text(Translations.current.yes()),
                  onPressed: () {
                    _logout(context);
                  },
                ),
                secondButton: MaterialButton(
                  // OPTIONAL BUTTON
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  color: Colors.white,
                  child: Text(Translations.current.no()),
                  onPressed: () {

                    Navigator.of(context).pop();
                  },
                ),
                icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
                yourWidget: Container(
                  child: Text(Translations.current.areYouSureToExit()),
                ));
          }),
          Divider(),
          ListTile(
            title: Text('1.0.0'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
