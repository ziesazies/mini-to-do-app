import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_to_do_app/presentation/blocs/login/login_event.dart';
import 'package:mini_to_do_app/presentation/blocs/login/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    // Simulasi login hardcoded
    await Future.delayed(Duration(seconds: 1));
    if (event.username == "admin" && event.password == "admin") {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("is_logged_in", true);
      emit(LoginSuccess());
    } else {
      emit(LoginFailure("Invalid username and password"));
    }
  }
}
