import 'dart:async';
import 'dart:io';

import 'package:blog/features/blog/data/models/blog_model.dart';
import 'package:blog/features/blog/domain/usecases/get_blogs.dart';
import 'package:blog/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetBlogs _getBlogs;
  BlogBloc({required UploadBlog uploadBlog, required GetBlogs getBlogs})
      : _uploadBlog = uploadBlog,
        _getBlogs = getBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUploadEvent>(_onBlogUpload);
    on<GetBlogsEvent>(_onGetBlogs);
  }

  FutureOr<void> _onBlogUpload(
      BlogUploadEvent event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(
        BlogUploadSuccess(),
      ),
    );
  }

  Future<FutureOr<void>> _onGetBlogs(
      GetBlogsEvent event, Emitter<BlogState> emit) async {
    final res = await _getBlogs(GetBlogParams());

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(
        BlogDisplaySuccess(r),
      ),
    );
  }
}
