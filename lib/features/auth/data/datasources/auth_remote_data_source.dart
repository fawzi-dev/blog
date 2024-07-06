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

