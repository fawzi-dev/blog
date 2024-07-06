// ignore_for_file: public_member_api_docs, sort_constructors_first

class BlogEntity {
  final String? id;
  final String? posterId;
  final String? title;
  final String? content;
  final String? imageUrl;
  final List<dynamic>? topics;
  final String? updatedAt;
  final String? posterName;

  BlogEntity({
    required this.id,
    required this.posterId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.topics,
    required this.updatedAt,
    this.posterName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'posterId': posterId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'topics': topics,
      'updated_at': updatedAt,
    };
  }

  factory BlogEntity.fromMap(Map<String, dynamic> map) {
    return BlogEntity(
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

  // String toJson() => json.encode(toMap());

  // factory BlogEntity.fromJson(String source) =>
  //     BlogEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  BlogEntity copyWith({
    String? id,
    String? posterId,
    String? title,
    String? content,
    String? imageUrl,
    List<String>? topics,
    String? updatedAt,
    String? posterName,
  }) {
    return BlogEntity(
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
