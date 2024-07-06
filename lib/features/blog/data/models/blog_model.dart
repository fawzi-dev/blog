import 'package:blog/features/blog/domain/entities/blog_entity.dart';

class BlogModel extends BlogEntity {
  BlogModel(
      {required super.id,
      required super.posterId,
      required super.title,
      required super.content,
      required super.imageUrl,
      required super.topics,
      required super.updatedAt,
      super.posterName});

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'poster_id': posterId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'topics': topics,
      'updated_at': updatedAt,
    };
  }

  factory BlogModel.fromMap(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] != null ? map['id'] as String : null,
      posterId: map['poster_id'] != null ? map['poster_id'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
      imageUrl: map['image_url'] != null ? map['image_url'] as String : null,
      topics: map['topics'] != null
          ? List<dynamic>.from((map['topics'] as List<dynamic>))
          : null,
      updatedAt: map['updated_at'] != null ? map['updated_at'] as String : null,
    );
  }

  @override
  BlogModel copyWith(
      {String? id,
      String? posterId,
      String? title,
      String? content,
      String? imageUrl,
      List<String>? topics,
      String? updatedAt,
      String? posterName}) {
    return BlogModel(
      id: id ?? this.id,
      posterId: posterId ?? this.posterId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      topics: topics ?? this.topics,
      updatedAt: updatedAt ?? this.updatedAt,
      posterName: posterName ?? this.posterName,
    );
  }
}
