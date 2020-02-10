import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:anad_magicar/bloc/register/register.dart';


class RegisterBloc extends Bloc<RegisterEvent,RegisterState>
{
  static final RegisterBloc _registerBlocSingleton = new RegisterBloc._internal();
  var currentObj;
  factory RegisterBloc() {
    return _registerBlocSingleton;
  }
  RegisterBloc._internal();

  RegisterState get initialState => new UnRegisterState();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
   try {

      yield await event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield state;
    }

  }


}
