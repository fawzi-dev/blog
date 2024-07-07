import 'package:blog/core/theme/app_pallete.dart';
import 'package:blog/core/utils/calculate_reading_time.dart';
import 'package:blog/features/blog/data/models/blog_model.dart';
import 'package:flutter/material.dart';

class BlogCardPage extends StatelessWidget {
  final BlogModel blog;
  final Color color;
  const BlogCardPage({
    super.key,
    required this.blog,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(16.0).copyWith(bottom: 2),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: blog.topics!
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Chip(
                        label: Text(e),
                        color: const WidgetStatePropertyAll(
                            AppPallete.backgroundColor),
                        side: null,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Text(
            blog.title ?? "",
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text('${calculateReadingTime(blog.content ?? '')} min')
        ],
      ),
    );
  }
}
