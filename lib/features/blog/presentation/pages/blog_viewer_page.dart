// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blog/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

import 'package:blog/features/blog/data/models/blog_model.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/calculate_reading_time.dart';
import '../../../../core/utils/format_date.dart';

class BlogViewerPage extends StatelessWidget {
  static route(BlogModel blog) => MaterialPageRoute(
        builder: (context) => BlogViewerPage(
          blogModel: blog,
        ),
      );

  BlogModel blogModel;
  BlogViewerPage({
    super.key,
    required this.blogModel,
  });

  @override
  Widget build(BuildContext context) {
    String dateText = formatDate(blogModel.updatedAt);
    int readingTimeText = calculateReadingTime(blogModel.content ?? '');

    // text theme
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Scrollbar(
          interactive: true,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blogModel.title ?? "",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Gap(16),
                Text(
                  'By ${blogModel.posterName}',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const Gap(4),
                Text(
                  '$dateText . $readingTimeText min',
                  style: textTheme.labelMedium!
                      .copyWith(color: AppPallete.greyColor),
                ),
                const Gap(8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 250,
                    child: Image.network(
                      blogModel.imageUrl ?? '',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Gap(16),
                Text(blogModel.content ?? '')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
