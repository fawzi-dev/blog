import 'dart:io';

import 'package:blog/core/error/failures.dart';
import 'package:blog/features/blog/data/models/blog_model.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<Failures, BlogModel>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  });

  Future<Either<Failures, List<BlogModel>>> getBlogs();
}
