import 'package:blog/core/error/exception.dart';
import 'package:blog/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemotedDataSource {
  Session? get currentUserSession;

  Future<UserModel> signInWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> loginInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemotedDataSource {
  final SupabaseClient client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Session? get currentUserSession => client.auth.currentSession;

  @override
  Future<UserModel> loginInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final res = await client.auth.signInWithPassword(
        password: password,
        email: email,
      );

      if (res.user == null) {
        throw const ServerException('User is null');
      }

      return UserModel.fromJson(res.user!.toJson())
          .copyWith(email: currentUserSession!.user.email);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await client.auth.signUp(
        password: password,
        email: email,
        data: {
          'name': name,
        },
      );

      if (res.user == null) {
        throw const ServerException('User is null');
      }

      return UserModel.fromJson(res.user!.toJson());
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await client.from('profiles').select().eq(
              'id',
              currentUserSession!.user.id,
            );
        return UserModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email,
        );
      }

      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
