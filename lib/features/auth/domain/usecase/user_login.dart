import 'package:blog/core/common/entities/user_entity.dart';
import 'package:blog/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

class UserLogin implements UseCase<UserEntity, UserLoginParam> {
  final AuthRepository authRepository;

  const UserLogin({required this.authRepository});

  @override
  Future<Either<Failures, UserEntity>> call(UserLoginParam param) async {
    return await authRepository.loginWithEmailPassword(
      email: param.email,
      password: param.password,
    );
  }
}

class UserLoginParam {
  final String email;
  final String password;
  UserLoginParam({required this.email, required this.password});
}
