import 'dart:io';

import 'package:blog/features/blog/data/datasources/remote/blog_remote_data_source.dart';
import 'package:blog/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/error/exception.dart';

class BlogRemoteDataSourceImpl implements BlogRemoteDataSources {
  final SupabaseClient client;

  BlogRemoteDataSourceImpl(this.client);

  @override
  Future<BlogModel> uploadBlog(BlogModel model) async {
    try {
      final response =
          await client.from('blogs').insert(model.toMap()).select();
      return BlogModel.fromMap(response.first);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadImage(
      {required File image, required BlogModel blogModel}) async {
    try {
      await client.storage
          .from('blog_images')
          .upload(blogModel.id.toString(), image);

      return client.storage
          .from('blog_images')
          .getPublicUrl(blogModel.id.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getBlogs() async {
    try {
      final response = await client.from('blogs').select('*, profiles (name)');
      return response
          .map((e) =>
              BlogModel.fromMap(e).copyWith(posterName: e['profiles']['name']))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on ServerException catch (e) {
      throw ServerException(e.message);
    }
  }
}
