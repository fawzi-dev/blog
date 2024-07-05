import 'dart:async';

import 'package:blog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog/core/common/entities/user_entity.dart';
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
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on(_signUpEvent);
    on(_loginIn);
    on(_onAuthIsUserLoggedIn);
  }

  Future<void> _loginIn(AuthLogin event, Emitter<AuthState> emit) async {
    final res = await _userLogin(UserLoginParam(
      email: event.email,
      password: event.password,
    ));

    res.fold(
      (failure) => emit(
        AuthFailure(failure.message),
      ),
      (user) => emitAuthSuccess(user, emit),
    );
  }

  FutureOr<void> _signUpEvent(AuthSignUp event, Emitter<AuthState> emit) async {
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
      (user) => emitAuthSuccess(user, emit),
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
        emitAuthSuccess(r, emit);
      },
    );
  }

  void emitAuthSuccess(UserEntity user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}
