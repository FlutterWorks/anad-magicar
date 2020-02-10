import 'dart:async';
import 'package:anad_magicar/bloc/car/register.dart';
import 'package:bloc/bloc.dart';



class RegisterCarBloc extends Bloc<RegisterEvent,RegisterState>
{
  static final RegisterCarBloc _registerBlocSingleton = new RegisterCarBloc._internal();
  var currentObj;
  factory RegisterCarBloc() {
    return _registerBlocSingleton;
  }
  RegisterCarBloc._internal();

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
