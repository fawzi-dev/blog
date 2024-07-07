import 'dart:io';
import 'package:blog/core/error/exception.dart';
import 'package:blog/core/error/failures.dart';
import 'package:blog/core/network/connection_checker.dart';
import 'package:blog/features/blog/data/datasources/local/blog_local_data_sources.dart';
import 'package:blog/features/blog/data/models/blog_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';
import '../../domain/repositories/blog_repository.dart';
import '../datasources/remote/blog_remote_data_source.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSources blogRemoteDataSources;
  final BlogLocalDateSource blogLocalDataSources;
  final ConnectionChecker connectionChecker;

  BlogRepositoryImpl({required this.blogRemoteDataSources, required this.blogLocalDataSources, required this.connectionChecker});
  

  @override
  Future<Either<Failures, BlogModel>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failures('No internet connection'));
      }
      // Blog mode
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId.toString(),
        title: title,
        content: content,
        imageUrl: 'image.toString()',
        topics: topics,
        updatedAt: DateTime.now().toString(),
      );

      final imgUrl = await blogRemoteDataSources.uploadImage(
        image: image,
        blogModel: blogModel,
      );

      blogModel = blogModel.copyWith(imageUrl: imgUrl);

      final uploadedBlog = await blogRemoteDataSources.uploadBlog(blogModel);

      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }

  @override
  Future<Either<Failures, List<BlogModel>>> getBlogs() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final blog = blogLocalDataSources.getBlogs();
        return right(blog);
      }
      final blogs = await blogRemoteDataSources.getBlogs();
      blogLocalDataSources.uploadBlog(blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }
}
