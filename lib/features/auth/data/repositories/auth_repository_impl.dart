import 'package:blog/core/error/exception.dart';
import 'package:blog/core/error/failures.dart';
import 'package:blog/core/network/connection_checker.dart';
import 'package:blog/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog/features/auth/data/models/user_model.dart';
import 'package:blog/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/common/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemotedDataSource authRemotedDataSource;
  final ConnectionChecker connectionChecker;
  AuthRepositoryImpl(
      {required this.authRemotedDataSource, required this.connectionChecker});

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
      if (!await connectionChecker.isConnected) {
        return left(
          Failures('No internet connection'),
        );
      }
      final user = await fn();
      return right(user);
    } on ServerException catch (e) {
      return left(
        Failures(e.message),
      );
    }
  }

  @override
  Future<Either<Failures, UserEntity>> currentUser() async {
    try {
      if (!await connectionChecker.isConnected) {
        final session = authRemotedDataSource.currentUserSession;

        if (session == session) {
          return left(
            Failures('User not logged in'),
          );
        }

        return right(
          UserModel(
              id: session?.user.id ?? '',
              name: '',
              email: session?.user.email ?? ''),
        );
      }
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
