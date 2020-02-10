import 'dart:async';

import 'package:anad_magicar/bloc/service_type/register.dart';
import 'package:bloc/bloc.dart';



class RegisterServiceTypeBloc extends Bloc<RegisterServiceTypeEvent,RegisterServiceTypeState>
{
  static final RegisterServiceTypeBloc _registerBlocSingleton = new RegisterServiceTypeBloc._internal();
  var currentObj;
  factory RegisterServiceTypeBloc() {
    return _registerBlocSingleton;
  }
  RegisterServiceTypeBloc._internal();

  RegisterServiceTypeState get initialState => new UnRegisterServiceTypeState();

  @override
  Stream<RegisterServiceTypeState> mapEventToState(RegisterServiceTypeEvent event) async* {
   try {
      yield await event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield state;
    }

  }


}
