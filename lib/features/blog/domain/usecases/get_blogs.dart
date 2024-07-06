// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:blog/core/error/failures.dart';
import 'package:blog/core/usecase/usecase.dart';
import 'package:blog/features/blog/data/models/blog_model.dart';
import 'package:blog/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetBlogs implements UseCase<List<BlogModel>, GetBlogParams> {
  BlogRepository blogRepository;
  GetBlogs({
    required this.blogRepository,
  });

  @override
  Future<Either<Failures, List<BlogModel>>> call(GetBlogParams params) async {
    return await blogRepository.getBlogs();
  }
}

class GetBlogParams {}
