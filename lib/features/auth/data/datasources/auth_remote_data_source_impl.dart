import 'package:blog/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exception.dart';
import '../models/user_model.dart';

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
