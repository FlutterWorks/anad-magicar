import 'dart:async';
import 'package:anad_magicar/bloc/service/register.dart';
import 'package:bloc/bloc.dart';



class RegisterCarServiceBloc extends Bloc<RegisterServiceEvent,RegisterServiceState>
{
  static final RegisterCarServiceBloc _registerBlocSingleton = new RegisterCarServiceBloc._internal();
  var currentObj;
  factory RegisterCarServiceBloc() {
    return _registerBlocSingleton;
  }
  RegisterCarServiceBloc._internal();

  RegisterServiceState get initialState => new UnRegisterServiceState();

  @override
  Stream<RegisterServiceState> mapEventToState(RegisterServiceEvent event) async* {
   try {
      yield await event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield state;
    }

  }


}
