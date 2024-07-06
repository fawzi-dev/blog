import 'dart:io';

import 'package:blog/features/blog/data/models/blog_model.dart';

abstract interface class BlogRemoteDataSources {
  Future<BlogModel> uploadBlog(BlogModel model);
  Future<List<BlogModel>> getBlogs();
  Future<String> uploadImage(
      {required File image, required BlogModel blogModel});
}
