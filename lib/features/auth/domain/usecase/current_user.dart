import 'package:blog/core/error/failures.dart';
import 'package:blog/core/usecase/usecase.dart';
import 'package:blog/features/auth/domain/entities/user_entity.dart';
import 'package:blog/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<UserEntity, NoParam> {
  final AuthRepository _authRepository;

  CurrentUser(this._authRepository);

  @override
  Future<Either<Failures, UserEntity>> call(NoParam param) async {
    return _authRepository.currentUser();
  }
}

class NoParam {}
