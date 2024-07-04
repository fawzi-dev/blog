import 'package:blog/core/error/exception.dart';
import 'package:blog/core/error/failures.dart';
import 'package:blog/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sup;
import '../../domain/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemotedDataSource authRemotedDataSource;

  AuthRepositoryImpl({required this.authRemotedDataSource});

  @override
  Future<Either<Failures, UserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await authRemotedDataSource.loginInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failures, UserEntity>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await authRemotedDataSource.signInWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failures, UserEntity>> _getUser(
      Future<UserEntity> Function() fn) async {
    try {
      final user = await fn();
      return right(user);
    } on sup.AuthException catch (e) {
      return left(
        Failures(e.message),
      );
    } on ServerException catch (e) {
      return left(
        Failures(e.message),
      );
    }
  }

  @override
  Future<Either<Failures, UserEntity>> currentUser() async {
    try {
      final user = await authRemotedDataSource.getUserData();

      if (user == null) {
        left(Failures('Current user not logged in'));
      }
      return right(user!);
    } on ServerException catch (e) {
      return left(
        Failures(e.message),
      );
    }
  }
}
