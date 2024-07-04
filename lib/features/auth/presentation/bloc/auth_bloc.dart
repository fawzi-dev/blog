import 'dart:async';

import 'package:blog/features/auth/domain/entities/user_entity.dart';
import 'package:blog/features/auth/domain/usecase/current_user.dart';
import 'package:blog/features/auth/domain/usecase/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/user_login.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        super(AuthInitial()) {
    on(_signUpEvent);
    on(_loginIn);
    on(_onAuthIsUserLoggedIn);
  }

  Future<void> _loginIn(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(UserLoginParam(
      email: event.email,
      password: event.password,
    ));

    res.fold(
      (failure) => emit(
        AuthFailure(failure.message),
      ),
      (user) => emit(
        AuthSuccess(user: user),
      ),
    );
  }

  FutureOr<void> _signUpEvent(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignUp(
      UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    res.fold(
      (failure) => emit(
        AuthFailure(failure.message),
      ),
      (user) => emit(
        AuthSuccess(user: user),
      ),
    );
  }

  void _onAuthIsUserLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUser(NoParam());

    res.fold(
      (l) {
        emit(
          AuthFailure(l.message),
        );
      },
      (r) {
        emit(
          AuthSuccess(user: r),
        );
      },
    );
  }
}
