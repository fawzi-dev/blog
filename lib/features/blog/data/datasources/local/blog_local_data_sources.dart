// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

import 'package:blog/features/blog/data/models/blog_model.dart';

abstract interface class BlogLocalDateSource {
  List<BlogModel> getBlogs();
  void uploadBlog(List<BlogModel> blog);
}

class BlogLocalDataSourceImpl implements BlogLocalDateSource {
  Box box;
  BlogLocalDataSourceImpl(this.box);

  @override
  List<BlogModel> getBlogs() {
    List<BlogModel> blogModels = [];

    box.read(() {
      for (var i = 0; i < box.length; i++) {
        blogModels.add(BlogModel.fromMap(box.get(i.toString())));
      }
    });

    return blogModels;
  }

  @override
  void uploadBlog(List<BlogModel> blog) {
    box.clear();

    for (var i = 0; i < blog.length; i++) {
      box.write(() {
        box.put(i.toString(), blog[i].toMap());
      });
    }
  }
}
