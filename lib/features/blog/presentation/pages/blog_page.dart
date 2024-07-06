import 'package:blog/core/common/widgets/loader.dart';
import 'package:blog/core/utils/show_snackbar.dart';
import 'package:blog/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/blog_bloc.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<BlogBloc>().add(GetBlogsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlogBloc, BlogState>(
      listener: (context, state) {
        if (state is BlogFailure) {
          showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is BlogLoading) {
          return const Loader();
        }

        final blogPosts = [];
        if (state is BlogDisplaySuccess) {
          blogPosts.addAll(state.posts);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Blog App'),
            actions: [
              IconButton(
                icon: const Icon(CupertinoIcons.add_circled),
                onPressed: () {
                  Navigator.push(context, AddNewBlogPage.route());
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
                child: Column(
              children: blogPosts
                  .map((e) => ListTile(
                        title: Text(e.title ?? ''),
                      ))
                  .toList(),
            )),
          ),
        );
      },
    );
  }
}
